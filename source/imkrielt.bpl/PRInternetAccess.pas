unit PRInternetAccess;

    {*****************************************************************************************************}
    {**************                                                                     ******************}
    {**************                 Progsan Internet User Agent Components              ******************}
    {**************                     Implements WinINET API                          ******************}
    {**************  SUPPORTS HTTP 1.1 [RFC 2616], FTP [RFC 0959] AND GOPHER [RFC 1437] ******************}
    {**************                                                                     ******************}
    {**************          Author : Erdal Payat [ epayat@progsan.com ]                ******************}
    {**************       Copyright Progsan® Software Gmbh All Rights Reserved          ******************}
    {**************                    version 1.1                                      ******************}
    {**************                                                                     ******************}
    {**************                    http://www.progsan.com                           ******************}
    {**************                                                                     ******************}
    {*****************************************************************************************************}

interface
uses consts, TypInfo, SysUtils, classes, sysconst, windows, messages,Registry, Contnrs, IniFiles,
     HTTPApp,WinInet,dialogs{,forms};


    {*****************************************************************************************************}
    {*************************************** DECLARATION SECTION *****************************************}
    {*****************************************************************************************************}


    {*****************************************************************************************************}
    {**************                                                                     ******************}
    {**************                     RFC 2616 HTTP Header Commands                   ******************}
    {**************     see: http://www.cis.ohio-state.edu/cgi-bin/rfc/rfc2616.html     ******************}
    {**************                                                                     ******************}
    {*****************************************************************************************************}



    {-----------------------------------------------------------------------------------------------------}
    {--------------                                                                     ------------------}
    {--------------          RFC 2616 Cache-Control Header Command Description          ------------------}
    {--------------                                                                     ------------------}
    {-----------------------------------------------------------------------------------------------------}
    {                                                                                                     }
    {    Cache-Control   = "Cache-Control" ":" 1#cache-directive                                          }
    {    cache-directive = cache-request-directive | cache-response-directive                             }
    {    cache-request-directive =                                                                        }
    {       "no-cache"                          ; Section 14.9.1                                          }
    {     | "no-store"                          ; Section 14.9.2                                          }
    {     | "max-age" "=" delta-seconds         ; Section 14.9.3, 14.9.4                                  }
    {     | "max-stale" [ "=" delta-seconds ]   ; Section 14.9.3                                          }
    {     | "min-fresh" "=" delta-seconds       ; Section 14.9.3                                          }
    {     | "no-transform"                      ; Section 14.9.5                                          }
    {     | "only-if-cached"                    ; Section 14.9.4                                          }
    {     | cache-extension                     ; Section 14.9.6                                          }
    {    cache-response-directive =                                                                       }
    {       "public"                               ; Section 14.9.1                                       }
    {     | "private" [ "=" <"> 1#field-name <"> ] ; Section 14.9.1                                       }
    {     | "no-cache" [ "=" <"> 1#field-name <"> ]; Section 14.9.1                                       }
    {     | "no-store"                             ; Section 14.9.2                                       }
    {     | "no-transform"                         ; Section 14.9.5                                       }
    {     | "must-revalidate"                      ; Section 14.9.4                                       }
    {     | "proxy-revalidate"                     ; Section 14.9.4                                       }
    {     | "max-age" "=" delta-seconds            ; Section 14.9.3                                       }
    {     | "s-maxage" "=" delta-seconds           ; Section 14.9.3                                       }
    {     | cache-extension                        ; Section 14.9.6                                       }
    {    cache-extension = token [ "=" ( token | quoted-string ) ]                                        }
    {                                                                                                     }
    {-----------------------------------------------------------------------------------------------------}

resourcestring
  sExceptionSessionRequired          = 'There is no Interet Session to make an Internet connection';
  sExceptionSessionActive            = 'Active Session must be closed before changing %s property!';
  sExceptionServerNameRequired       = 'ServerName Required.';
  sExceptionConnectionActive         = 'Active Connection must be closed before changing %s property!';
  sExceptionUnknownHttpHeaderCommand = 'Supplied API FLAG %d does not coresspond a [RFC 2616] Header Command.';
  sExceptionAcceptTypesNotAssigned   = 'AcceptTypes expected.';
  sExceptionInvalidScheme            = 'Requested Scheme is invalid in this context.Valid schemes are [%s]';
  sExceptionUnknownScheme            = '%s is an unknown or invalid scheme.';
  sExceptionConnectionExpected       = 'Internet Connection Property is not set';
  sExceptionCookieNotFound           = 'There is no cookie that named %s';

  sApiError = 'WININET Error: %s'+sLineBreak+'Code: %d.';

  sMsgNotConnected  = '[not connected]';
  //Progress Messages
  sProgressMessage_ClosingConnection    = 'Closing Connection...';
  sProgressMessage_ConnectedToServer    = 'Contacted with Host %s.';
  sProgressMessage_ConnectingToServer   = 'Trying to connect %s.';
  sProgressMessage_ConnectionClosed     = 'Connection Sucessfuly Closed.';
  sProgressMessage_DetectingProxy       = 'Trying to Detect Proxy Confiuration...';
  sProgressMessage_ClosingHandle        = 'Releasing Socket...';
  sProgressMessage_HandleCreated        = 'Socket Initialized.';
  sProgressMessage_IntermediateResponse = 'Response Received. (%d)';
  sProgressMessage_NameResolved         = 'Host Name Resolved as %s.';
  sProgressMessage_WaitingForResponse   = 'Waiting for Response...';
  sProgressMessage_Redirect             = 'Redirecting to URL %s.';
  sProgressMessage_RequestCompleted     = 'Request has been successfully completed.';
  sProgressMessage_RequestSent          = 'Request has been sent (%d bytes).';
  sProgressMessage_ResponseReceived     = 'Response Received (%d bytes).';
  sProgressMessage_ResolvingName        = 'Resolving Host %s.';
  sProgressMessage_SendingRequest       = 'Sending Request...';
  sProgressMessage_StateChange          = 'State Changed (%d)';
  sProgressMessage_CookieSent           = 'Sending Cookies (%d)';
  sProgressMessage_CookieReceived       = 'Receiving Cookies (%d)';
  //Api Error Descriptions
  sERROR_FTP_DROPPED                      = 'The FTP operation was not completed because the session was aborted.';
  sERROR_FTP_NO_PASSIVE_MODE              = 'Passive mode is not available on the server.';
  sERROR_FTP_TRANSFER_IN_PROGRESS         = 'The requested operation cannot be made on the FTP session handle because an operation is already in progress.';
  sERROR_GOPHER_ATTRIBUTE_NOT_FOUND       = 'The requested attribute could not be located.';
  sERROR_GOPHER_DATA_ERROR                = 'An error was detected while receiving data from the Gopher server.';
  sERROR_GOPHER_END_OF_DATA               = 'The end of the data has been reached.';
  sERROR_GOPHER_INCORRECT_LOCATOR_TYPE    = 'The type of the locator is not correct for this operation.';
  sERROR_GOPHER_INVALID_LOCATOR           = 'The supplied locator is not valid.';
  sERROR_GOPHER_NOT_FILE                  = 'The request must be made for a file locator.';
  sERROR_GOPHER_NOT_GOPHER_PLUS           = 'The requested operation can be made only against a Gopher+ server, or with a locator that specifies a Gopher+ operation.';
  sERROR_GOPHER_PROTOCOL_ERROR            = 'An error was detected while parsing data returned from the Gopher server.';
  sERROR_GOPHER_UNKNOWN_LOCATOR           = 'The locator type is unknown.';
  sERROR_HTTP_COOKIE_DECLINED             = 'The HTTP cookie was declined by the server.';
  sERROR_HTTP_COOKIE_NEEDS_CONFIRMATION   = 'The HTTP cookie requires confirmation.';
  sERROR_HTTP_DOWNLEVEL_SERVER            = 'The server did not return any headers.';
  sERROR_HTTP_HEADER_ALREADY_EXISTS       = 'The header could not be added because it already exists.';
  sERROR_HTTP_HEADER_NOT_FOUND            = 'The requested header could not be located.';
  sERROR_HTTP_INVALID_HEADER              = 'The supplied header is invalid.';
  sERROR_HTTP_INVALID_QUERY_REQUEST       = 'The request made to HttpQueryInfo is invalid.';
  sERROR_HTTP_INVALID_SERVER_RESPONSE     = 'The server response could not be parsed.';
  sERROR_HTTP_NOT_REDIRECTED              = 'The HTTP request was not redirected.';
  sERROR_HTTP_REDIRECT_FAILED             =  'The redirection failed because either the scheme changed (for example, HTTP to FTP) or all attempts made to redirect failed (default is five attempts).';
  sERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION = 'The redirection requires user confirmation.';
  sERROR_INTERNET_ASYNC_THREAD_FAILED     = 'The application could not start an asynchronous thread.';
  sERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT   = 'There was an error in the automatic proxy configuration script.';
  sERROR_INTERNET_BAD_OPTION_LENGTH       = 'The length of an option supplied to InternetQueryOption or InternetSetOption is incorrect for the type of option specified.';
  sERROR_INTERNET_BAD_REGISTRY_PARAMETER  = 'A required registry value was located but is an incorrect type or has an invalid value.';
  sERROR_INTERNET_CANNOT_CONNECT          = 'The attempt to connect to the server failed.';
  sERROR_INTERNET_CHG_POST_IS_NON_SECURE  = 'The application is posting and attempting to change multiple lines of text on a server that is not secure.';
  sERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED = 'The server is requesting client authentication.';
  sERROR_INTERNET_CLIENT_AUTH_NOT_SETUP   = 'Client authorization is not set up on this computer.';
  sERROR_INTERNET_CONNECTION_ABORTED      = 'The connection with the server has been terminated.';
  sERROR_INTERNET_CONNECTION_RESET        = 'The connection with the server has been reset.';
  sERROR_INTERNET_DIALOG_PENDING          = 'Another thread has a password dialog box in progress.';
  sERROR_INTERNET_DISCONNECTED            = 'The Internet connection has been lost.';
  sERROR_INTERNET_EXTENDED_ERROR          = 'An extended error was returned from the server. This is typically a string or buffer containing a verbose error message. Call InternetGetLastResponseInfo to retrieve the error text.';
  sERROR_INTERNET_FAILED_DUETOSECURITYCHECK = 'The function failed due to a security check.';
  sERROR_INTERNET_FORCE_RETRY             = 'The Win32 Internet function needs to redo the request.';
  sERROR_INTERNET_FORTEZZA_LOGIN_NEEDED   = 'The requested resource requires Fortezza authentication.';
  sERROR_INTERNET_HANDLE_EXISTS           = 'The request failed because the handle already exists.';
  sERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR  = 'The application is moving from a non-SSL to an SSL connection because of a redirect.';
  sERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR = 'The data being submitted to an SSL connection is being redirected to a non-SSL connection.';
  sERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR  = 'The application is moving from an SSL to an non-SSL connection because of a redirect.';
  sERROR_INTERNET_INCORRECT_FORMAT        = 'The format of the request is invalid.';
  sERROR_INTERNET_INCORRECT_HANDLE_STATE  = 'The requested operation cannot be carried out because the handle supplied is not in the correct state.';
  sERROR_INTERNET_INCORRECT_HANDLE_TYPE   = 'The type of handle supplied is incorrect for this operation.';
  sERROR_INTERNET_INCORRECT_PASSWORD      = 'The request to connect and log on to an FTP server could not be completed because the supplied password is incorrect.';
  sERROR_INTERNET_INCORRECT_USER_NAME     = 'The request to connect and log on to an FTP server could not be completed because the supplied user name is incorrect.';
  sERROR_INTERNET_INSERT_CDROM            = 'The request requires a CD-ROM to be inserted in the CD-ROM drive to locate the resource requested.';
  sERROR_INTERNET_INTERNAL_ERROR          = 'An internal error has occurred.';
  sERROR_INTERNET_INVALID_CA              = 'The function is unfamiliar with the Certificate Authority that generated the server''s certificate.';
  sERROR_INTERNET_INVALID_OPERATION       = 'The requested operation is invalid.';
  sERROR_INTERNET_INVALID_OPTION          = 'A request to InternetQueryOption or InternetSetOption specified an invalid option value.';
  sERROR_INTERNET_INVALID_PROXY_REQUEST   = 'The request to the proxy was invalid.';
  sERROR_INTERNET_INVALID_URL             = 'The URL is invalid.';
  sERROR_INTERNET_ITEM_NOT_FOUND          = 'The requested item could not be located.';
  sERROR_INTERNET_LOGIN_FAILURE           = 'The request to connect and log on to an FTP server failed.';
  sERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY = 'The MS-Logoff digest header has been returned from the Web site. This header specifically instructs the digest package to purge credentials for the associated realm.';
  sERROR_INTERNET_MIXED_SECURITY          = 'The content is not entirely secure. Some of the content being viewed may have come from unsecured servers.';
  sERROR_INTERNET_NAME_NOT_RESOLVED       = 'The server name could not be resolved.';
  sERROR_INTERNET_NEED_MSN_SSPI_PKG       = 'Not currently implemented.';
  sERROR_INTERNET_NEED_UI                 = 'A user interface or other blocking operation has been requested.';
  sERROR_INTERNET_NO_CALLBACK             = 'An asynchronous request could not be made because a callback function has not been set.';
  sERROR_INTERNET_NO_CONTEXT              = 'An asynchronous request could not be made because a zero context value was supplied.';
  sERROR_INTERNET_NO_DIRECT_ACCESS        = 'Direct network access cannot be made at this time.';
  sERROR_INTERNET_NOT_INITIALIZED         = 'Initialization of the Win32 Internet API has not occurred. Indicates that a higher-level function, such as InternetOpen, has not been called yet.';
  sERROR_INTERNET_NOT_PROXY_REQUEST       = 'The request cannot be made via a proxy.';
  sERROR_INTERNET_OPERATION_CANCELLED     = 'The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.';
  sERROR_INTERNET_OPTION_NOT_SETTABLE     = 'The requested option cannot be set, only queried.';
  sERROR_INTERNET_OUT_OF_HANDLES          = 'No more handles could be generated at this time.';
  sERROR_INTERNET_POST_IS_NON_SECURE      = 'The application is posting data to a server that is not secure.';
  sERROR_INTERNET_PROTOCOL_NOT_FOUND      = 'The requested protocol could not be located.';
  sERROR_INTERNET_PROXY_SERVER_UNREACHABLE = 'The designated proxy server cannot be reached.';
  sERROR_INTERNET_REDIRECT_SCHEME_CHANGE   = 'The function could not handle the redirection, because the scheme changed (for example, HTTP to FTP).';
  sERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND = 'A required registry value could not be located.';
  sERROR_INTERNET_REQUEST_PENDING         = 'The required operation could not be completed because one or more requests are pending.';
  sERROR_INTERNET_RETRY_DIALOG            = 'The dialog box should be retried.';
  sERROR_INTERNET_SEC_CERT_CN_INVALID     = 'SSL certificate common name (host name field) is incorrect—for example, if you entered www.server.com and the common name on the certificate says www.different.com.';
  sERROR_INTERNET_SEC_CERT_DATE_INVALID   = 'SSL certificate date that was received from the server is bad. The certificate is expired.';
  sERROR_INTERNET_SEC_CERT_ERRORS         = 'The SSL certificate contains errors.';
  sERROR_INTERNET_SEC_CERT_NO_REV         = 'ERROR_INTERNET_SEC_CERT_REV_FAILED';
  sERROR_INTERNET_SEC_CERT_REVOKED        = 'SSL certificate was revoked.';
  sERROR_INTERNET_SEC_INVALID_CERT        = 'SSL certificate is invalid.';
  sERROR_INTERNET_SECURITY_CHANNEL_ERROR  = 'The application experienced an internal error loading the SSL libraries.';
  sERROR_INTERNET_SERVER_UNREACHABLE      = 'The Web site or server indicated is unreachable.';
  sERROR_INTERNET_SHUTDOWN                = 'The Win32 Internet function support is being shut down or unloaded.';
  sERROR_INTERNET_TCPIP_NOT_INSTALLED     = 'The required protocol stack is not loaded and the application cannot start WinSock.';
  sERROR_INTERNET_TIMEOUT                 = 'The request has timed out.';
  sERROR_INTERNET_UNABLE_TO_CACHE_FILE    = 'The function was unable to cache the file.';
  sERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT = 'The automatic proxy configuration script could not be downloaded. The INTERNET_FLAG_MUST_CACHE_REQUEST flag was set.';
  sERROR_INTERNET_UNRECOGNIZED_SCHEME     = 'The URL scheme could not be recognized, or is not supported.';
  sERROR_INVALID_HANDLE                   = 'The handle that was passed to the API has been either invalidated or closed. (Win32 error code)';
  sERROR_MORE_DATA                        = 'More data is available. (Win32 error code)';
  sERROR_NO_MORE_FILES                    = 'No more files have been found. (Win32 error code)';
  sERROR_NO_MORE_ITEMS                    = 'No more items have been found. (Win32 error code)';
  sERROR_UNKNOWN_ERROR                    = 'Unknown API Error Occurred.';

const
    INTERNET_SCHEME_SOCKS      = INTERNET_SCHEME_MAILTO + 1;
    INTERNET_SCHEME_JAVASCRIPT = INTERNET_SCHEME_MAILTO + 2;
    INTERNET_SCHEME_VBSCRIPT   = INTERNET_SCHEME_MAILTO + 3;
    INTERNET_DEFAULT_NEWS_PORT = 119;
    //CUSTOM API MESSAGE CONST
    WM_INTERNET_CALLBACK      = WM_USER + $3000;
type
    ENotSupportedException = class (Exception);
    EInvalidScheme         = class (Exception);
    EWinInetApiError = class(Exception)
    public
      ErrorCode: DWORD;
    end;
    PWM_CALLBACK_REC = ^TWM_CALLBACK_REC;
    TWM_CALLBACK_REC = record
      hInet:HINTERNET;
      dwContext:DWORD;
      dwInternetStatus:DWORD;
      lpvStatusInformation:pointer;
      dwStatusInformationLength:DWORD
    end;

    THTTPHeaderCommands = (
      hcAccept,              // RFC 2616 Definition:  Accept              = "Accept" ":" #( media-range [ accept-params ] ) -> media-range    = ( "*/*" | ( type "/" "*" ) | ( type "/" subtype ) ) *( ";" parameter ) -> accept-params  = ";" "q" "=" qvalue *( accept-extension ) -> accept-extension = ";" token [ "=" ( token | quoted-string ) ]  [  EX : Accept: text/*;q=0.3, text/html;q=0.7, text/html;level=1, text/html;level=2;q=0.4, */*;q=0.5  ]
      hcAcceptCharset,       // RFC 2616 Definition:  Accept-Charset      = "Accept-Charset" ":"  1#( ( charset | "*" )[ ";" "q" "=" qvalue ] )   [ EX : Accept-Charset: iso-8859-5, unicode-1-1;q=0.8 ]
      hcAcceptEncoding,      // RFC 2616 Definition:  Accept-Encoding     = "Accept-Encoding" ":" 1#( codings [ ";" "q" "=" qvalue ] ) -> codings          = ( content-coding | "*" )    [  EXs :  Accept-Encoding: compress, gzip | Accept-Encoding: gzip;q=1.0, identity; q=0.5, *;q=0  ]
      hcAcceptLanguage,      // RFC 2616 Definition:  Accept-Language     = "Accept-Language" ":" 1#( language-range [ ";" "q" "=" qvalue ] ) -> language-range  = ( ( 1*8ALPHA *( "-" 1*8ALPHA ) ) | "*" )   [ EX :  Accept-Language: da, en-gb;q=0.8, en;q=0.7  ]
      hcAcceptRanges,        // RFC 2616 Definition:  Accept-Ranges       = "Accept-Ranges" ":" acceptable-ranges -> acceptable-ranges = 1#range-unit | "none"  [ EX: Accept-Ranges: bytes ]
      hcAge,                 // RFC 2616 Definition:  Age                 = "Age" ":" age-value  -> age-value = delta-seconds
      hcAllow,               // RFC 2616 Definition:  Allow               = "Allow" ":" #Method  [  EX :  Allow: GET, HEAD, PUT  ]
      hcAuthorization,       // RFC 2616 Definition:  Authorization       = "Authorization" ":" credentials
      hcCacheControl,        // RFC 2616 Definition:  Cache-Control       = "Cache-Control" ":" 1#cache-directive   -> (see RFC 2616 Cache-Control Header Command Description above)
      hcConnection,          // RFC 2616 Definition:  Connection          = "Connection" ":" 1#(connection-token) -> connection-token  = token    [ EX :  Connection: close  ]
      hcContentBase,         // RFC 2616 Definition:  Content-Base        = "Content-Base" ":" absoluteURI
      hcContentId,           // Possible Microsoft Extension it is not defined in neither  RFC 2616 nor RFC 2068
      hcContentEncoding,     // RFC 2616 Definition:  Content-Encoding    = "Content-Encoding" ":" 1#content-coding   [ EX  :  Content-Encoding: gzip ]
      hcContentLanguage,     // RFC 2616 Definition:  Content-Language    = "Content-Language" ":" 1#language-tag
      hcContentLength,       // RFC 2616 Definition:  Content-Length      = "Content-Length" ":" 1*DIGIT
      hcContentLocation,     // RFC 2616 Definition:  Content-Location    = "Content-Location" ":" ( absoluteURI | relativeURI )
      hcContentMD5,          // RFC 2616 Definition:  Content-MD5         = "Content-MD5" ":" md5-digest -> md5-digest = <base64 of 128 bit MD5 digest as per RFC 1864>
      hcContentRange,        // RFC 2616 Definition:  Content-Range       = "Content-Range" ":" content-range-spec -> content-range-spec = byte-content-range-spec -> byte-content-range-spec = bytes-unit SP byte-range-resp-spec "/" ( instance-length | "*" ) -> byte-range-resp-spec = (first-byte-pos "-" last-byte-pos) | "*" -> instance-length = 1*DIGIT
      hcContentTransEncoding,// RFC 2616 Definition:  UNKNOWN!!!
      hcContentType,         // RFC 2616 Definition:  Content-Type        = "Content-Type" ":" media-type
      hcCookie,              // Netscape Extension :  Cookie Header Field of Client Request
      hcDate,                // RFC 2616 Definition:  Date                = "Date" ":" HTTP-date
      hcETag,                // RFC 2616 Definition:  ETag                = "ETag" ":" entity-tag
      hcExpect,              // RFC 2616 Definition:  Expect              =  "Expect" ":" 1#expectation -> expectation  =  "100-continue" | expectation-extension -> expectation-extension =  token [ "=" ( token | quoted-string ) *expect-params ] ->  expect-params =  ";" token [ "=" ( token | quoted-string ) ]
      hcExpires,             // RFC 2616 Definition:  Expires             = "Expires" ":" HTTP-date
      hcFrom,                // RFC 2616 Definition:  From                = "From" ":" mailbox [  EX:  From: webmaster@w3.org  ]
      hcHost,                // RFC 2616 Definition:  Host                = "Host" ":" host [ ":" port ]
      hcIfMatch,             // RFC 2616 Definition:  If-Match            = "If-Match" ":" ( "*" | 1#entity-tag )
      hcIfModifiedSince,     // RFC 2616 Definition:  If-Modified-Since   = "If-Modified-Since" ":" HTTP-date
      hcIfNoneMatch,         // RFC 2616 Definition:  If-None-Match       = "If-None-Match" ":" ( "*" | 1#entity-tag )
      hcIfRange,             // RFC 2616 Definition:  If-Range            = "If-Range" ":" ( entity-tag | HTTP-date )
      hcIfUnmodifiedSince,   // RFC 2616 Definition:  If-Unmodified-Since = "If-Unmodified-Since" ":" HTTP-date
      hcKeepAlive,           // Unknown Extension to RFC 2616
      hcLastModified,        // RFC 2616 Definition:  Last-Modified       = "Last-Modified" ":" HTTP-date
      hcLocation,            // RFC 2616 Definition:  Location            = "Location" ":" absoluteURI
      hcMaxForwards,         // RFC 2616 Definition:  Max-Forwards        = "Max-Forwards" ":" 1*DIGIT
      hcMethod,              // RFC 2616 Definition:  Method              = "OPTIONS"   | "GET"  | "HEAD"  | "POST"  | "PUT" | "DELETE" | "TRACE" | "CONNECT" | extension-method -> extension-method = token
      hcMimeVersion,         // RFC 2616 Definition:  MIME-Version        = "MIME-Version" ":" 1*DIGIT "." 1*DIGIT
      hcPragma,              // RFC 2616 Definition:  Pragma              = "Pragma" ":" 1#pragma-directive -> pragma-directive  = "no-cache" | extension-pragma -> extension-pragma  = token [ "=" ( token | quoted-string ) ]
      hcProxyConnection,     // Possible Microsoft Extension it is not defined in neither  RFC 2616 nor RFC 2068
      hcProxyAuthenticate,   // RFC 2616 Definition:  Proxy-Authenticate  = "Proxy-Authenticate" ":" 1#challenge
      hcProxyAuthorization,  // RFC 2616 Definition:  Proxy-Authorization = "Proxy-Authorization" ":" credentials
      hcPublic,              // RFC 2616 Definition:  Public              = "Public" ":" 1#method
      hcRange,               // RFC 2616 Definition:  Range               = "Range" ":" ranges-specifier  [WARNING :only meaningful if the response carries a status code of 206 (Partial Content) ] ranges-specifier = byte-ranges-specifier -> byte-ranges-specifier = bytes-unit "=" byte-range-set -> byte-range-set  = 1#( byte-range-spec | suffix-byte-range-spec ) -> byte-range-spec = first-byte-pos "-" [last-byte-pos] -> first-byte-pos  = 1*DIGIT -> last-byte-pos   = 1*DIGIT
      hcReferrer,            // RFC 2616 Definition:  Referer             = "Referer" ":" ( absoluteURI | relativeURI )          [ EX:  Referer: http://www.w3.org/hypertext/DataSources/Overview.html ]
      hcRetryAfter,          // RFC 2616 Definition:  Retry-After         = "Retry-After" ":" ( HTTP-date | delta-seconds )
      hcServer,              // RFC 2616 Definition:  Server              = "Server" ":" 1*( product | comment )
      hcSetCookie,           // Netscape Extension :  Header Field of Server Respond
      hcStatusCode,          // RFC 2616 Definition:  must be placed just after HTTP version
      hcStatusText,          // RFC 2616 Definition:  must be placed just after Status Code
      hcTE,                  // RFC 2616 Definition:  TE                  = "TE" ":" #( t-codings ) -> t-codings = "trailers" | ( transfer-extension [ accept-params ] )    [ EX :  TE: trailers, deflate;q=0.5]
      hcTrailer,             // RFC 2616 Definition:  Trailer             = "Trailer" ":" 1#field-name
      hcTransferEncoding,    // RFC 2616 Definition:  Transfer-Encoding   = "Transfer-Encoding" ":" 1#transfer-coding   [ EX: Transfer-Encoding: chunked ]
      hcUpgrade,             // RFC 2616 Definition:  Upgrade             = "Upgrade" ":" 1#product                              [ EX:  Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11 ]
      hcUnlessModifiedSince, // UNKNOWN EXTENSION
      hcUserAgent,           // RFC 2616 Definition:  User-Agent          = "User-Agent" ":" 1*( product | comment )
      hcVary,                // RFC 2616 Definition:  Vary                = "Vary" ":" ( "*" | 1#field-name )
      hcVersion,
      hcVia ,                // RFC 2616 Definition:  Via                 =  "Via" ":" 1#( received-protocol received-by [ comment ] ) -> received-protocol = [ protocol-name "/" ] protocol-version -> protocol-name     = token , protocol-version  = token, received-by       = ( host [ ":" port ] ) | pseudonym -> pseudonym         = token
      hcWarning,             // RFC 2616 Definition:  Warning             = "Warning" ":" 1#warning-value -> warning-value = warn-code SP warn-agent SP warn-text -> warn-code  = 3DIGIT , warn-agent = ( host [ ":" port ] ) | pseudonym
      hcWWWAuthenticate,     // RFC 2616 Definition:  WWW-Authenticate    = "WWW-Authenticate" ":" 1#challenge
      hcUnknown              // any other extension to RFC 2616
      );
  TAsyncStatus = (asInit,asReading,asCancelled,asFinished);
  TInternetConnectionTypes = (
      ictUnknown,
      ictHTTP,
      ictFTP,
      ictGOPHER
  );
  TInternetHttpMethods = (
    hmGET,
    hmHEAD,
    hmPOST,
    hmPUT,
    hmDELETE,
    hmTRACE,
    hmCONNECT
  );
  THTTPCookieHandlingTypes = (
    chAPI,                     //  Cookies Handled by WININET API. This should be default value.
    chNative,                  //  Cookies Handled by Native Components.
    chNone                     //  No Cookie Handling. In this mode all cookies, that are sent by server, will be denied and also no cookies will be sent.
  );
  TInternetHandleTypes = (
      ihtCONNECT_FTP,
      ihtCONNECT_GOPHER,
      ihtCONNECT_HTTP,
      ihtFILE_REQUEST,
      ihtFTP_FILE,
      ihtFTP_FILE_HTML,
      ihtFTP_FIND,
      ihtFTP_FIND_HTML,
      ihtGOPHER_FILE,
      ihtGOPHER_FILE_HTML,
      ihtGOPHER_FIND,
      ihtGOPHER_FIND_HTML,
      ihtHTTP_REQUEST,
      ihtINTERNET,
      ihtUnknown
      );
  TInternetAccessTypes = (
    atDirect,                   // [INTERNET_OPEN_TYPE_DIRECT]                      : Resolves all host names locally.
    atPreConfig,                // [INTERNET_OPEN_TYPE_PRECONFIG]                   : Retrieves the proxy or direct configuration from the registry.
    atPreConfigNoProxy,         // [INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY] : Retrieves the proxy or direct configuration from the registry and prevents the use of a startup Microsoft JScript® or Internet Setup (INS) file.
    atProxy                     // [INTERNET_OPEN_TYPE_PROXY]                       : Passes requests to the proxy unless a proxy bypass list is supplied and the name to be resolved bypasses the proxy.
    );                          //                                                     In this case, the function uses INTERNET_OPEN_TYPE_DIRECT.

  TInternetSchemes = (
    isPartial,                   // [INTERNET_SCHEME_PARTIAL]    : Partial URL.
    isUnknown,                   // [INTERNET_SCHEME_UNKNOWN]    : Unknown URL scheme.
    isDefault,                   // [INTERNET_SCHEME_DEFAULT]    : Default URL scheme.
    isFTP,                       // [INTERNET_SCHEME_FTP]        : FTP URL scheme (ftp:)
    isGOPHER,                    // [INTERNET_SCHEME_GOPHER]     : Gopher URL scheme (gopher:).
    isHTTP,                      // [INTERNET_SCHEME_HTTP]       : HTTP URL scheme (http:).
    isHTTPS,                     // [INTERNET_SCHEME_HTTPS]      : HTTPS URL scheme (https:).
    isFILE,                      // [INTERNET_SCHEME_FILE]       : File URL scheme (file:).
    isNEWS,                      // [INTERNET_SCHEME_NEWS]       : News URL scheme (news:).
    isMAILTO,                    // [INTERNET_SCHEME_MAILTO]     : Mail URL scheme (mailto:).
    isSocks,                     // [INTERNET_SCHEME_SOCKS]      : Socks URL scheme (socks:).
    isJScript,                   // [INTERNET_SCHEME_JAVASCRIPT] : JScript URL scheme (javascript:).
    isVBScript                   // [INTERNET_SCHEME_VBSCRIPT]   : Microsoft VBScript URL scheme (vbscript:).

  );
 TInternetURLCrackOption=(
   icoDECODE,         // Converts encoded characters back to their normal form.                     [API FLAG: ICU_DECODE]
   icoESCAPE,         // Converts all escape sequences (%xx) to their corresponding characters      [API FLAG: ICU_ESCAPE]
   icoUSERNAME        // When adding the user name, uses the name that was specified at logon time. [API FLAG: ICU_USERNAME]
 );
 TInternetURLCrackOptions=set of TInternetURLCrackOption;
const
  c_default_document_size = 40 * 1204;       // this constant will be used as content-length if server dont return content-length header field in order to calculate progress..

  c_HTTPHeaderGeneralCmds  : set of THTTPHeaderCommands = [hcCacheControl, hcConnection, hcContentId, hcContentTransEncoding, hcDate, hcPragma,
                                                           hcTrailer, hcTransferEncoding, hcUpgrade, hcVia, hcWarning];

  c_HTTPHeaderRequestCmds  : set of THTTPHeaderCommands = [hcAccept, hcAcceptCharset, hcAcceptEncoding, hcAcceptLanguage, hcAuthorization,
                                                           hcExpect, hcFrom, hcHost, hcIfMatch, hcIfModifiedSince, hcIfNoneMatch, hcIfRange,
                                                           hcIfUnmodifiedSince, hcMaxForwards, hcProxyAuthorization, hcPublic, hcRange, hcReferrer,
                                                           hcTE, hcUserAgent, hcCookie];

  c_HTTPHeaderResponseCmds : set of THTTPHeaderCommands = [hcVersion,hcAcceptRanges, hcAge, hcETag, hcLocation, hcProxyAuthenticate, hcRetryAfter,
                                                           hcServer, hcStatusCode, hcStatusText, hcVary, hcVersion, hcWWWAuthenticate, hcSetCookie,
                                                           hcKeepAlive];

  c_InternetAPISchemeMapping     : array [TInternetSchemes] of integer = (
    {isPartial}                   INTERNET_SCHEME_PARTIAL,
    {isUnknown}                   INTERNET_SCHEME_UNKNOWN,
    {isDefault}                   INTERNET_SCHEME_DEFAULT,
    {isFTP}                       INTERNET_SCHEME_FTP,
    {isGOPHER}                    INTERNET_SCHEME_GOPHER,
    {isHTTP}                      INTERNET_SCHEME_HTTP,
    {isHTTPS}                     INTERNET_SCHEME_HTTPS,
    {isFILE}                      INTERNET_SCHEME_FILE,
    {isNEWS}                      INTERNET_SCHEME_NEWS,
    {isMAILTO}                    INTERNET_SCHEME_MAILTO,
    {isSocks}                     INTERNET_SCHEME_SOCKS,
    {isJScript}                   INTERNET_SCHEME_JAVASCRIPT,
    {isVBScript}                  INTERNET_SCHEME_VBSCRIPT
  );
  c_InternetSchemeIDs      : array [TInternetSchemes] of string = (
    {isPartial}                   '/',
    {isUnknown}                   '',
    {isDefault}                   'http',
    {isFTP}                       'ftp',
    {isGOPHER}                    'gopher',
    {isHTTP}                      'http',
    {isHTTPS}                     'https',
    {isFILE}                      'file',
    {isNEWS}                      'news',
    {isMAILTO}                    'mailto',
    {isSocks}                     'socks',
    {isJScript}                   'jscript',
    {isVBScript}                  'vbscript'
  );

  c_InternetDefaultSchemePorts    : array [TInternetSchemes] of dword = (
    {isPartial}                   INTERNET_INVALID_PORT_NUMBER,
    {isUnknown}                   INTERNET_INVALID_PORT_NUMBER,
    {isDefault}                   INTERNET_INVALID_PORT_NUMBER,
    {isFTP}                       INTERNET_DEFAULT_FTP_PORT,
    {isGOPHER}                    INTERNET_DEFAULT_GOPHER_PORT,
    {isHTTP}                      INTERNET_DEFAULT_HTTP_PORT,
    {isHTTPS}                     INTERNET_DEFAULT_HTTPS_PORT,
    {isFILE}                      INTERNET_INVALID_PORT_NUMBER,
    {isNEWS}                      INTERNET_DEFAULT_NEWS_PORT,
    {isMAILTO}                    INTERNET_INVALID_PORT_NUMBER,
    {isSocks}                     INTERNET_DEFAULT_SOCKS_PORT,
    {isJScript}                   INTERNET_INVALID_PORT_NUMBER,
    {isVBScript}                  INTERNET_INVALID_PORT_NUMBER
  );

  c_HTTPHeaderCommandIds         : array [THTTPHeaderCommands] of string = (
      {hcAccept}              'Accept',
      {hcAcceptCharset}       'Accept-Charset',
      {hcAcceptEncoding}      'Accept-Encoding',
      {hcAcceptLanguage}      'Accept-Language',
      {hcAcceptRanges}        'Accept-Ranges',
      {hcAge}                 'Age',
      {hcAllow}               'Allow',
      {hcAuthorization}       'Authorization',
      {hcCacheControl}        'Cache-Control',
      {hcConnection}          'Connection',
      {hcContentBase}         'Content-Base',
      {hcContentEncoding}     'Content-Encoding',
      {hcContentId}           'Content-Id',
      {hcContentLanguage}     'Content-Language',
      {hcContentLength}       'Content-Length',
      {hcContentLocation}     'Content-Location',
      {hcContentMD5}          'Content-MD5',
      {hcContentRange}        'Content-Range',
      {hcContentTransEncoding}'Content-Transfer-Encoding',
      {hcContentType}         'Content-Type',
      {hcCookie}              'Cookie',         //ex: Cookie: JServSessionIdroot=1fbabn3418; name=value ...
      {hcDate}                'Date',
      {hcETag}                'ETag',
      {hcExpect}              'Expect',
      {hcExpires}             'Expires',
      {hcFrom}                'From',
      {hcHost}                'Host',
      {hcIfMatch}             'If-Match',
      {hcIfModifiedSince}     'If-Modified-Since',
      {hcIfNoneMatch}         'If-None-Match',
      {hcIfRange}             'If-Range',
      {hcIfUnmodifiedSince}   'If-Unmodified-Since',
      {hcKeepAlive}           'Keep-Alive',     //ex: Keep-Alive: timeout=15, max=100
      {hcLastModified}        'Last-Modified',
      {hcLocation}            'Location',
      {hcMaxForwards}         'Max-Forwards',
      {hcMethod}              'Method',
      {hcMimeVersion}         'MIME-Version',
      {hcPragma}              'Pragma',
      {hcProxyConnection}     'Proxy-Connection',
      {hcProxyAuthenticate}   'Proxy-Authenticate',
      {hcProxyAuthorization}  'Proxy-Authorization',
      {hcPublic}              'Public',
      {hcRange}               'Range',
      {hcReferrer}            'Referer',
      {hcRetryAfter}          'Retry-After',
      {hcServer}              'Server',
      {hcSetCookie}           'Set-Cookie',     //ex: Set-Cookie: JServSessionIdroot=1fbabn3418; path=/
      {hcStatusCode}          '',               //must be just after the version info for ex: HTTP/1.1 200 OK
      {hcStatusText}          '',               //must be just after the status code for ex: HTTP/1.1 200 OK
      {hcTE}                  'TE',
      {hcTrailer}             'Trailer',
      {hcTransferEncoding}    'Transfer-Encoding',
      {hcUpgrade}             'Upgrade',
      {hcUnlessModifiedSince} 'Unless-Modified-Since',  // UNKNOWN EXTENSION
      {hcUserAgent}           'User-Agent',
      {hcVary}                'Vary',
      {hcVersion}             'HTTP/',          //ex: HTTP/1.1 200 OK
      {hcVia }                'Via',
      {hcWarning}             'Warning',
      {hcWWWAuthenticate}     'WWW-Authenticate',
      {hcUnknown}             ''
   );

  {**********************    FOLLOWING HEADER QUERY MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  HTTP_QUERY_WARNING               = 67;
  HTTP_QUERY_EXPECT                = 68;
  HTTP_QUERY_PROXY_CONNECTION      = 69;
  HTTP_QUERY_UNLESS_MODIFIED_SINCE = 70;
  HTTP_QUERY_ECHO_REQUEST          = 71;
  HTTP_QUERY_ECHO_REPLY            = 72;

  // These are the set of headers that should be added back to a request when
  // re-doing a request after a RETRY_WITH response.
  HTTP_QUERY_ECHO_HEADERS          = 73;
  HTTP_QUERY_ECHO_HEADERS_CRLF     = 74;

  HTTP_QUERY_PROXY_SUPPORT         = 75;
  HTTP_QUERY_AUTHENTICATION_INFO   = 76;
  HTTP_QUERY_PASSPORT_URLS         = 77;
  HTTP_QUERY_PASSPORT_CONFIG       = 78;

  HTTP_QUERY_MAX                   = HTTP_QUERY_PASSPORT_CONFIG;
  HTTP_QUERY_NOT_SUPPORTED         =$FFFFFFFF;  //means that header not implemented by MS-INET API and must managed as additional header

  {**********************    FOLLOWING INTERNET OPTION MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  INTERNET_OPTION_LISTEN_TIMEOUT             = 11;

  INTERNET_OPTION_FROM_CACHE_TIMEOUT         = 63;
  INTERNET_OPTION_BYPASS_EDITED_ENTRY        = 64;
  INTERNET_OPTION_CODEPAGE                   = 68;
  INTERNET_OPTION_CACHE_TIMESTAMPS           = 69;
  INTERNET_OPTION_DISABLE_AUTODIAL           = 70;
  INTERNET_OPTION_MAX_CONNS_PER_SERVER       = 73;
  INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER   = 74;
  INTERNET_OPTION_PER_CONNECTION_OPTION      = 75;
  INTERNET_OPTION_DIGEST_AUTH_UNLOAD         = 76;
  INTERNET_OPTION_IGNORE_OFFLINE             = 77;
  INTERNET_OPTION_IDENTITY                   = 78;
  INTERNET_OPTION_REMOVE_IDENTITY            = 79;
  INTERNET_OPTION_ALTER_IDENTITY             = 80;
  INTERNET_OPTION_SUPPRESS_BEHAVIOR          = 81;
  INTERNET_OPTION_AUTODIAL_MODE              = 82;
  INTERNET_OPTION_AUTODIAL_CONNECTION        = 83;
  INTERNET_OPTION_CLIENT_CERT_CONTEXT        = 84;
  INTERNET_OPTION_AUTH_FLAGS                 = 85;
  INTERNET_OPTION_COOKIES_3RD_PARTY          = 86;
  INTERNET_OPTION_DISABLE_PASSPORT_AUTH      = 87;
  INTERNET_OPTION_SEND_UTF8_SERVERNAME_TO_PROXY = 88;
  INTERNET_OPTION_EXEMPT_CONNECTION_LIMIT    = 89;
  INTERNET_OPTION_ENABLE_PASSPORT_AUTH       = 90;

  INTERNET_OPTION_HIBERNATE_INACTIVE_WORKER_THREADS       = 91;
  INTERNET_OPTION_ACTIVATE_WORKER_THREADS                 = 92;
  INTERNET_OPTION_RESTORE_WORKER_THREAD_DEFAULTS          = 93;
  INTERNET_OPTION_SOCKET_SEND_BUFFER_LENGTH               = 94;
  INTERNET_OPTION_PROXY_SETTINGS_CHANGED                  = 95;

  INTERNET_LAST_OPTION                   = INTERNET_OPTION_PROXY_SETTINGS_CHANGED;

  //
  // values for INTERNET_OPTION_PRIORITY
  //

  INTERNET_PRIORITY_FOREGROUND           = 1000;

  INTERNET_HANDLE_TYPE_UNKNOWN           = 0;


  {**********************    FOLLOWING STATUS ID MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  INTERNET_STATUS_DETECTING_PROXY         = 080;
  INTERNET_STATUS_USER_INPUT_REQUIRED     = 140;
  INTERNET_STATUS_STATE_CHANGE            = 200;
  INTERNET_STATUS_COOKIE_SENT             = 320;
  INTERNET_STATUS_COOKIE_RECEIVED         = 321;
  INTERNET_STATUS_PRIVACY_IMPACTED        = 324;
  INTERNET_STATUS_P3P_HEADER              = 325;
  INTERNET_STATUS_P3P_POLICYREF           = 326;
  INTERNET_STATUS_COOKIE_HISTORY          = 327;
  INTERNET_STATUS_DOWNLOADING             = INTERNET_STATUS_COOKIE_HISTORY+2001;
  INTERNET_STATUS_PARSING                 = INTERNET_STATUS_COOKIE_HISTORY+2002;


  {**********************    FOLLOWING REQUEST FLAG MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  INTERNET_REQFLAG_CACHE_WRITE_DISABLED = $00000040;  // HTTPS: this request not cacheable
  INTERNET_REQFLAG_NET_TIMEOUT          = $00000080;  // w/ _FROM_CACHE: net request timed out

  {**********************    FOLLOWING SECURITY FLAG MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  SECURITY_FLAG_FORTEZZA                  = $08000000;

  {**********************    FOLLOWING ERROR CODE MANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  ERROR_INTERNET_NEED_UI                            = INTERNET_ERROR_BASE + 34;
  ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED              = INTERNET_ERROR_BASE + 54;
  ERROR_INTERNET_SEC_CERT_ERRORS                    = INTERNET_ERROR_BASE + 55;
  ERROR_INTERNET_SEC_CERT_NO_REV                    = INTERNET_ERROR_BASE + 56;
  ERROR_INTERNET_SEC_CERT_REV_FAILED                = INTERNET_ERROR_BASE + 57;
  ERROR_INTERNET_NOT_INITIALIZED                    = INTERNET_ERROR_BASE + 172;
  ERROR_INTERNET_NEED_MSN_SSPI_PKG                  = INTERNET_ERROR_BASE + 173;
  ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY  = INTERNET_ERROR_BASE + 174;

  INTERNET_ERROR_LAST                               = ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY;

  {**********************    FOLLOWING ERROR MASK FLAGMANIFESTS NOT DEFINED IN WININET.PAS     ****************************}

  INTERNET_ERROR_MASK_INSERT_CDROM                      =$01;
  INTERNET_ERROR_MASK_COMBINED_SEC_CERT                 =$02;
  INTERNET_ERROR_MASK_NEED_MSN_SSPI_PKG                 =$04;
  INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY =$08;
  //
  // flags field masks
  //

  SECURITY_INTERNET_MASK  = INTERNET_FLAG_IGNORE_CERT_CN_INVALID    or
                            INTERNET_FLAG_IGNORE_CERT_DATE_INVALID  or
                            INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS  or
                            INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;
                            
  c_HTTPHeaderCommandWINInetMapping: array [THTTPHeaderCommands] of dword = (
      {hcAccept}              HTTP_QUERY_ACCEPT,                     // (24) Retrieves the acceptable media types for the response.
      {hcAcceptCharset}       HTTP_QUERY_ACCEPT_CHARSET,             // (25) Retrieves the acceptable character sets for the response.
      {hcAcceptEncoding}      HTTP_QUERY_ACCEPT_ENCODING,            // (26) Retrieves the acceptable content-coding values for the response.
      {hcAcceptLanguage}      HTTP_QUERY_ACCEPT_LANGUAGE,            // (27) Retrieves the acceptable natural languages for the response.
      {hcAcceptRanges}        HTTP_QUERY_ACCEPT_RANGES,              // (42) Retrieves the types of range requests that are accepted for a resource.
      {hcAge}                 HTTP_QUERY_AGE,                        // (48) Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
      {hcAllow}               HTTP_QUERY_ALLOW,                      // (07) Receives  the HTTP verbs supported by the server.
      {hcAuthorization}       HTTP_QUERY_AUTHORIZATION,              // (28) Retrieves the authorization credentials used for a request.
      {hcCacheControl}        HTTP_QUERY_CACHE_CONTROL,              // (49) Retrieves the cache control directives.
      {hcConnection}          HTTP_QUERY_CONNECTION,                 // (23) Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
      {hcContentBase}         HTTP_QUERY_CONTENT_BASE,               // (50) Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
      {hcContentId}           HTTP_QUERY_CONTENT_ID,                 // (03) Retrieves the content identification.
      {hcContentEncoding}     HTTP_QUERY_CONTENT_ENCODING,           // (29) Retrieves any additional content codings that have been applied to the entire resource.
      {hcContentLanguage}     HTTP_QUERY_CONTENT_LANGUAGE,           // (06) Retrieves the language that the content is in.
      {hcContentLength}       HTTP_QUERY_CONTENT_LENGTH,             // (05) Retrieves the size of the resource, in bytes.
      {hcContentLocation}     HTTP_QUERY_CONTENT_LOCATION,           // (51) Retrieves the resource location for the entity enclosed in the message.
      {hcContentMD5}          HTTP_QUERY_CONTENT_MD5,                // (52) Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
      {hcContentRange}        HTTP_QUERY_CONTENT_RANGE,              // (53) Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
      {hcContentTransEncoding}HTTP_QUERY_CONTENT_TRANSFER_ENCODING,  // (02) Receives the additional content coding that has been applied to the resource.
      {hcContentType}         HTTP_QUERY_CONTENT_TYPE,               // (01) Receives the content type of the resource (such as text/html).
      {hcCookie}              HTTP_QUERY_COOKIE,                     // (44) Retrieves any cookies associated with the request.
      {hcDate}                HTTP_QUERY_DATE,                       // (09) Receives the date and time at which the message was originated.
      {hcETag}                HTTP_QUERY_ETAG,                       // (54) Retrieves the entity tag for the associated entity.
      {hcExpect}              HTTP_QUERY_EXPECT,                     // (68) Retrieves the Expect header, which indicates whether the client application should expect 100 series responses.
      {hcExpires}             HTTP_QUERY_EXPIRES,                    // (10) Receives the date and time after which the resource should be considered outdated.
      {hcFrom}                HTTP_QUERY_FROM,                       // (31) Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
      {hcHost}                HTTP_QUERY_HOST,                       // (55) Retrieves the Internet host and port number of the resource being requested.
      {hcIfMatch}             HTTP_QUERY_IF_MATCH,                   // (56) Retrieves the contents of the If-Match request-header field.
      {hcIfModifiedSince}     HTTP_QUERY_IF_MODIFIED_SINCE,          // (32) Retrieves the contents of the If-Modified-Since header.
      {hcIfNoneMatch}         HTTP_QUERY_IF_NONE_MATCH,              // (57) Retrieves the contents of the If-None-Match request-header field.
      {hcIfRange}             HTTP_QUERY_IF_RANGE,                   // (58) Retrieves the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
      {hcIfUnmodifiedSince}   HTTP_QUERY_IF_UNMODIFIED_SINCE,        // (59) Retrieves the contents of the If-Unmodified-Since request-header field.
      {hcKeepAlive}           HTTP_QUERY_NOT_SUPPORTED,              // (-1) There is no known matching MS INET API Identifier for this header field!!!
      {hcLastModified}        HTTP_QUERY_LAST_MODIFIED,              // (11) Receives the date and time at which the server believes the resource was last modified.
      {hcLocation}            HTTP_QUERY_LOCATION,                   // (33) Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
      {hcMaxForwards}         HTTP_QUERY_MAX_FORWARDS,               // (60) Retrieves the number of proxies or gateways that can forward the request to the next inbound server.
      {hcMethod}              HTTP_QUERY_REQUEST_METHOD,             // (45) Receives the HTTP verb that is being used in the request, typically GET or POST.
      {hcMimeVersion}         HTTP_QUERY_MIME_VERSION,               // (00) Receives the version of the MIME protocol that was used to construct the message.
      {hcPragma}              HTTP_QUERY_PRAGMA,                     // (17) Receives the implementation-specific directives that might apply to any recipient along the request/response chain.
      {hcProxyConnection}     HTTP_QUERY_PROXY_CONNECTION,           // (69) Retrieves the Proxy-Connection header.
      {hcProxyAuthenticate}   HTTP_QUERY_PROXY_AUTHENTICATE,         // (41) Retrieves the authentication scheme and realm returned by the proxy.
      {hcProxyAuthorization}  HTTP_QUERY_PROXY_AUTHORIZATION,        // (61) Retrieves the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
      {hcPublic}              HTTP_QUERY_PUBLIC,                     // (08) Receives methods available at this server.
      {hcRange}               HTTP_QUERY_RANGE,                      // (62) Retrieves the byte range of an entity.
      {hcReferrer}            HTTP_QUERY_REFERER,                    // (35) Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
      {hcRetryAfter}          HTTP_QUERY_RETRY_AFTER,                // (36) Retrieves the amount of time the service is expected to be unavailable.
      {hctServer}             HTTP_QUERY_SERVER,                     // (37) Retrieves information about the software used by the origin server to handle the request.
      {hcSetCookie}           HTTP_QUERY_SET_COOKIE,                 // (43) Receives the value of the cookie set for the request.
      {hcStatusCode}          HTTP_QUERY_STATUS_CODE,                // (19) Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
      {hcStatusText}          HTTP_QUERY_STATUS_TEXT,                // (20) Receives any additional text returned by the server on the response line.
      {hcTE}                  HTTP_QUERY_NOT_SUPPORTED,              // (-1) There is no known matching MS INET API Identifier for this header field!!!
      {hcTrailer}             HTTP_QUERY_NOT_SUPPORTED,              // (-1) There is no known matching MS INET API Identifier for this header field!!!
      {hcTransferEncoding}    HTTP_QUERY_TRANSFER_ENCODING,          // (63) Retrieves the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
      {hcUpgrade}             HTTP_QUERY_UPGRADE,                    // (64) Retrieves the additional communication protocols that are supported by the server.
      {hcUnlessModifiedSince} HTTP_QUERY_UNLESS_MODIFIED_SINCE,      // UNKNOWN EXTENSION
      {hcUserAgent}           HTTP_QUERY_USER_AGENT,                 // (39) Retrieves information about the user agent that made the request.
      {hcVary}                HTTP_QUERY_VARY,                       // (65) Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
      {hcVersion}             HTTP_QUERY_VERSION,                    // (18) Receives the last response code returned by the server.
      {hcVia }                HTTP_QUERY_VIA,                        // (66) Retrieves the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
      {hcWarning}             HTTP_QUERY_WARNING,                    // (67) Retrieves additional information about the status of a response that might not be reflected by the response status code.
      {hcWWWAuthenticate}     HTTP_QUERY_WWW_AUTHENTICATE,           // (40) Retrieves the authentication scheme and realm returned by the server.
      {hcUnknown}             HTTP_QUERY_CUSTOM                      // (65535) Causes HttpQueryInfo to search for the header name specified in lpvBuffer and store the header information in lpvBuffer.
  );

  c_InternetHandleTypeWINInetMapping: array [TInternetHandleTypes] of dword = (
      {ihtCONNECT_FTP}        INTERNET_HANDLE_TYPE_CONNECT_FTP,
      {ihtCONNECT_GOPHER}     INTERNET_HANDLE_TYPE_CONNECT_GOPHER,
      {ihtCONNECT_HTTP}       INTERNET_HANDLE_TYPE_CONNECT_HTTP,
      {ihtFILE_REQUEST}       INTERNET_HANDLE_TYPE_CONNECT_HTTP,
      {ihtFTP_FILE}           INTERNET_HANDLE_TYPE_FTP_FILE,
      {ihtFTP_FILE_HTML}      INTERNET_HANDLE_TYPE_FTP_FILE_HTML,
      {ihtFTP_FIND}           INTERNET_HANDLE_TYPE_FTP_FIND,
      {ihtFTP_FIND_HTML}      INTERNET_HANDLE_TYPE_FTP_FIND_HTML,
      {ihtGOPHER_FILE}        INTERNET_HANDLE_TYPE_GOPHER_FILE,
      {ihtGOPHER_FILE_HTML}   INTERNET_HANDLE_TYPE_GOPHER_FILE_HTML,
      {ihtGOPHER_FIND}        INTERNET_HANDLE_TYPE_GOPHER_FIND,
      {ihtGOPHER_FIND_HTML}   INTERNET_HANDLE_TYPE_GOPHER_FIND_HTML,
      {ihtHTTP_REQUEST}       INTERNET_HANDLE_TYPE_HTTP_REQUEST,
      {ihtINTERNET}           INTERNET_HANDLE_TYPE_INTERNET,
      {ihtUnknown}            0
  );

  c_InternetAccessTypeWINInetMapping: array [TInternetAccessTypes] of dword = (
    {atDirect}                    INTERNET_OPEN_TYPE_DIRECT,                      // Resolves all host names locally.
    {atPreConfig}                 INTERNET_OPEN_TYPE_PRECONFIG,                   // Retrieves the proxy or direct configuration from the registry.
    {atPreConfigNoProxy}          INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY, // Retrieves the proxy or direct configuration from the registry and prevents the use of a startup Microsoft JScript® or Internet Setup (INS) file.
    {atProxy}                     INTERNET_OPEN_TYPE_PROXY                        // Passes requests to the proxy unless a proxy bypass list is supplied and the name to be resolved bypasses the proxy.
    );                                                                            //     In this case, the function uses INTERNET_OPEN_TYPE_DIRECT.

(***********************  FOLLOWING MS-INET QUERY FLAGS ARE NOT HEADER FIELDS *******************************************

HTTP_QUERY_CONTENT_DESCRIPTION         // (04) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_CONTENT_DISPOSITION         // (47) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_COST                        // (15) No longer supported.
HTTP_QUERY_DERIVED_FROM                // (14) No longer supported.
HTTP_QUERY_ECHO_HEADERS                // (73) Not currently implemented.
HTTP_QUERY_ECHO_HEADERS_CRLF           // (74) Not currently implemented.
HTTP_QUERY_ECHO_REPLY                  // (72) Not currently implemented.
HTTP_QUERY_ECHO_REQUEST                // (71) Not currently implemented.
HTTP_QUERY_FORWARDED                   // (30) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_LINK                        // (16) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_MAX                         // (75) Not a query flag. Indicates the maximum value of an HTTP_QUERY_* value.
HTTP_QUERY_MESSAGE_ID                  // (12) No longer supported.
HTTP_QUERY_ORIG_URI                    // (34) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_RAW_HEADERS                 // (21) Receives all the headers returned by the server. Each header is terminated by "\0". An additional "\0" terminates the list of headers.
HTTP_QUERY_RAW_HEADERS_CRLF            // (22) Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
HTTP_QUERY_REFRESH                     // (46) Obsolete. Maintained for legacy application compatibility only.
HTTP_QUERY_TITLE                       // (38) Obsolete. Maintained for legacy application compatibility only.

***********************  FOLLOWING MS-INET QUERY FLAGS DONT MATCH RFC 2616 *******************************************
HTTP_QUERY_UNLESS_MODIFIED_SINCE       // (70) Retrieves the Unless-Modified-Since header.
HTTP_QUERY_URI                         // (13) Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.

*)

{ PROTOTYPES}
function InternetTimeToSystemTime(
      lpszTime: LPSTR;
      var pst: TSystemTime;
      dwReserved: DWORD): BOOL; stdcall;


type
  TInternetTimeToSystemTime=function(
      lpszTime: LPSTR;
      var pst: TSystemTime;
      dwReserved: DWORD): BOOL; stdcall;

  LPINTERNET_CACHE_TIMESTAMPS = ^INTERNET_CACHE_TIMESTAMPS;
  INTERNET_CACHE_TIMESTAMPS = RECORD
    ftExpires: TFILETIME;
    ftLastModified:TFILETIME;
  end;

  LPINTERNET_PER_CONN_OPTION = ^INTERNET_PER_CONN_OPTION;
  INTERNET_PER_CONN_OPTION = record
    dwOption: DWORD;
    case integer of
        0: (dwValue:DWORD);
        1: (pszValue:LPTSTR);
        2: (ftValue:FILETIME);
   end;


  // INTERNET_PER_CONN_OPTION_LIST - set per-connection options such as proxy
  // and autoconfig info
  //
  // Set and queried using Internet[Set|Query]Option with
  // INTERNET_OPTION_PER_CONNECTION_OPTION

  LPINTERNET_PER_CONN_OPTION_LIST = ^INTERNET_PER_CONN_OPTION_LIST;
  INTERNET_PER_CONN_OPTION_LIST = record
    dwSize: DWORD;
    pszConnection: LPTSTR;
    dwOptionCount: DWORD;
    dwOptionError: DWORD;
    pOptions: LPINTERNET_PER_CONN_OPTION;
  end;

  // INTERNET_ASYNC_RESULT - this structure is returned to the application via
  // the callback with INTERNET_STATUS_REQUEST_COMPLETE. It is not sufficient to
  // just return the result of the async operation. If the API failed then the
  // app cannot call GetLastError() because the thread context will be incorrect.
  // Both the value returned by the async API and any resultant error code are
  // made available. The app need not check dwError if dwResult indicates that
  // the API succeeded (in this case dwError will be ERROR_SUCCESS)

  LPINTERNET_ASYNC_RESULT = ^INTERNET_ASYNC_RESULT;
  INTERNET_ASYNC_RESULT =record
      dwResult: DWORD;      //the HINTERNET, DWORD or BOOL return code from an async API
      dwError: DWORD;        //the error code if the API failed
  end;


  PURL_Components = ^TUrl_Components;
  TURL_Components = record
    Scheme: string;               { scheme name }
    nScheme: TInternetSchemes;    { enumerated scheme type (if known) }
    HostName: string;             { host name }
    nPort: INTERNET_PORT;         { converted port number }
    pad: WORD;                    { force correct allignment regardless of comp. flags}
    UserName: string;             { user name }
    Password: string;             { password }
    UrlPath: string;              { URL-path }
    ExtraInfo: string;            { extra information (e.g. ?foo or #foo) }
  end;

type
  TINETApi_Intf            = class;
  TInternetFile            = class;
  TCustomInternetComponent = class;
  TCustomInternetSession   = class;
  TCustomInternetRequest   = class;
  TCustomInternetConnection= class;
  THTTPCookies             = class;
  THTTPCookie              = class;

  { ***********************************************  Event Prototypes  ****************************************************}
  PInternetCallbackContext = ^TInternetCallbackContext;
  TInternetCallbackContext = record
    CallbackID   : dword;                 // A Unigue unsigned 32 bit integer value.
    pOwner       : pointer;               // A Pointer to owner object that the callback belong to
    pOwnerHandle : HINTERNET;             // API Handle of owner object.
    pAppData     : pointer;               // Application defined data if any.
    pReserved    : pointer                // Reserved must be nil.
  end;
  TInternet_Status_Callback_proc   = procedure (hInet:HINTERNET;dwContext:DWORD;dwInternetStatus:DWORD;lpvStatusInformation:pointer;dwStatusInformationLength:DWORD) of object;
  TInternetOnProgressEvent         = procedure (Sender:TObject;hInet:HINTERNET;Progress,ProgressMax, StatusCode: Cardinal;
                                                StatusText: string; ElapsedTime, EstimatedTime:TDatetime;Speed :extended; SpeedUnit: string) of object;
  TInternetOnResponseEvent         = procedure (Sender:TObject;hInet:HINTERNET;ResponseCode: Cardinal; ResponseHeaders,
                                                RequestHeaders: string;var AdditionalRequestHeaders: string) of object;
  TInternetOnBeginTransactionEvent = procedure (Sender:TObject;hInet:HINTERNET;URL, Headers: string; Reserved: Cardinal;
                                                var AdditionalHeaders: string) of object;
  TInternetOnAuthenticateEvent     = procedure (Sender:TObject;hInet:HINTERNET;var hwnd: HWND; var UserName, PassWord: string) of object;
  TInternetOnDownloadCompleteEvent = procedure (Sender:TObject;hInet:HINTERNET; DownloadedFile:TInternetFile;
                                                ElapsedTime:TDateTime; AvgSpeed: extended;AvgSpeedUnit: string) of object;
  TInternetOnDataEvent             = procedure (Sender:TObject;hInet:HINTERNET; Buffer :pchar; BufferLength: cardinal) of object;
  TInternetOnSecurityProblem       = procedure (Sender:TObject;hInet:HINTERNET;dwProblem: cardinal; Description: string) of object;
  TInternetOnConnectingEvent       = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr,ServerPort:string) of object;
  TInternetOnConnectedEvent         = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr,ServerPort:string) of object;
  TInternetOnClosingConnectionEvent= procedure (Sender:TObject;hInet:HINTERNET;ServerAddr:string) of object;
  TInternetOnConnectionClosedEvent = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr:string) of object;
  TInternetOnDetectingProxyEvent   = procedure (Sender:TObject;hInet:HINTERNET;DetectedProxy, DetectedProxyPort:string) of object;
  TInternetOnHandleCreatedEvent    = procedure (Sender:TObject;hInet:HINTERNET;pAsyncResult:LPINTERNET_ASYNC_RESULT) of object;
  TInternetOnHandleClosingEvent    = procedure (Sender:TObject;hInet:HINTERNET) of object;
  TInternetOnIntermediateResponseEvent = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr,ServerPort:string;
                                                    StatusCode: dword; StatusDesc:string) of object;
  TInternetOnResolvingHostNameEvent= procedure (Sender:TObject;hInet:HINTERNET;ServerAddr:string) of object;
  TInternetOnHostNameResolvedEvent = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr,IPAddress:string) of object;
  TInternetOnWaitingForResponseEvent = procedure (Sender:TObject;hInet:HINTERNET;ServerAddr,ServerPort:string) of object;
  TInternetOnRedirectEvent         = procedure (Sender:TObject;hInet:HINTERNET; OldURL, NewURL: String;var cancel:boolean) of object;
  TInternetOnRequestCompleteEvent  = procedure (Sender:TObject;hInet:HINTERNET;pAsyncResult:LPINTERNET_ASYNC_RESULT) of object;
  TInternetOnRequestSentEvent      = procedure (Sender:TObject;hInet:HINTERNET) of object;
  TInternetNotifyEvent             = procedure (Sender:TObject;hInet:HINTERNET) of object;
  TInternetOnLoadedEvent           = procedure (Sender:TObject;hInet:HINTERNET; Stream:TStream) of object;


  TInternetCallbackHolder = class (TObject)
  private
    fInet         : HINTERNET;
    fCallbackProc : TInternet_Status_Callback_proc;
    fContext      : PInternetCallbackContext;
  protected
    procedure doOnCallback(hInet:HINTERNET;dwContext:DWORD;dwInternetStatus:DWORD;lpvStatusInformation:pointer;dwStatusInformationLength:DWORD);
  public
    property hInet: HINTERNET read fInet write fInet;
    property Context : PInternetCallbackContext read fContext write fContext;
    property CallBackProc : TInternet_Status_Callback_proc read fCallbackProc write fCallbackProc;
  end;
  { **** The following object contains the options supported by InternetQueryOption and InternetSetOption.
         All valid option flags have a value greater than or equal to INTERNET_FIRST_OPTION and less than or equal to INTERNET_LAST_OPTION.
    INTERNET_OPTION_ASYNC                   : Not currently implemented.
    INTERNET_OPTION_ASYNC_ID                : Not implemented.
    INTERNET_OPTION_ASYNC_PRIORITY          : Not currently implemented.
    INTERNET_OPTION_BYPASS_EDITED_ENTRY     : Sets or retrieves the Boolean value that determines if the system should check the network for newer content and overwrite edited cache entries if a newer version is found. If set to TRUE, the system will check the network for newer content and overwrite the edited cache entry with the newer version. The default is FALSE, which indicates that the edited cache entry should be used without checking the network. This is used by InternetQueryOption and InternetSetOption. It is valid only in Microsoft® Internet Explorer 5 and later.
    INTERNET_OPTION_CACHE_STREAM_HANDLE     : No longer supported.
    INTERNET_OPTION_CACHE_TIMESTAMPS        : Retrieves an INTERNET_CACHE_TIMESTAMPS structure that contains the LastModified time and Expires time from the resource stored in the Internet cache. This value is used by InternetQueryOption.
    INTERNET_OPTION_CALLBACK                : Sets or retrieves the address of the callback function defined for this handle. This option can be used on all HINTERNET handles. Used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_CALLBACK_FILTER         : Not currently implemented.
    INTERNET_OPTION_CLIENT_CERT_CONTEXT     : This flag is not supported by InternetQueryOption. The LPVOID(lpBuffer) parameter must be a pointer to a CERT CONTEXT structure and not a pointer to a CERT CONTEXT pointer. If an application receives ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED, it must call InternetErrorDlg or use InternetSetOption to supply a certificate before retrying the request. CertDuplicateCertificateContext is then called so that the certificate context passed can be independently released by the application.
    INTERNET_OPTION_CODEPAGE                : Not currently implemented.
    INTERNET_OPTION_CONNECT_BACKOFF         : Not currently implemented.
    INTERNET_OPTION_CONNECT_RETRIES         : Sets or retrieves an unsigned long integer value that contains the number of times Microsoft Win32® Internet (WinInet) will attempt to resolve and connect to a host. WinInet will only attempt once per IP address. For example, if you attempt to connect to a multihome host that has ten IP addresses and INTERNET_OPTION_CONNECT_RETRIES is set to seven, WinInet will only attempt to resolve and connect to the first seven IP address. Conversely, given the same set of ten IP addresses, if INTERNET_OPTION_CONNECT_RETRIES is set to 20 WinInet will attempt each of the ten only once.
                                              If a host has only one IP address and the first connection attempt fails, there will be no further attempts. If a connection attempt still fails after the specified number of attempts, the request is canceled. The default value for INTERNET_OPTION_CONNECT_RETRIES is five attempts. This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption
    INTERNET_OPTION_CONNECT_TIME            : Not currently implemented.
    INTERNET_OPTION_CONNECT_TIMEOUT         : Sets or retrieves an unsigned long integer value that contains the time-out value to use for Internet connection requests. Units are in milliseconds. If a connection request takes longer than this time-out value, the request is canceled. When attempting to connect to multiple IP addresses for a single host (a multihome host), the timeout limit is cumulative for all of the IP addresses. This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_CONNECTED_STATE         : Sets or retrieves an unsigned long integer value that contains the connected state. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_CONTEXT_VALUE           : Sets or retrieves a DWORD_PTR that contains the address of the context value associated with this HINTERNET handle. This option can be used on any HINTERNET handle. This is used by InternetQueryOption and InternetSetOption. Previously, this set the context value to the address stored in the DWORD(lpBuffer) pointer. This has been corrected so that the value stored in the buffer will be used and the INTERNET_OPTION_CONTEXT_VALUE flag will be assigned a new value. The old value, 10, has been preserved so that applications written for the old behavior are still supported.
    INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT : Identical to INTERNET_OPTION_RECEIVE_TIMEOUT. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_CONTROL_SEND_TIMEOUT    : Identical to INTERNET_OPTION_SEND_TIMEOUT. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_DATA_RECEIVE_TIMEOUT    : Not implemented.
    INTERNET_OPTION_DATA_SEND_TIMEOUT       : Not implemented.
    INTERNET_OPTION_DATAFILE_NAME           : Retrieves a string value that contains the name of the file backing a downloaded entity. This flag is valid after InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest has completed. It is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_DIGEST_AUTH_UNLOAD      : Causes the system to log off the Digest authentication SSPI package, purging all of the credentials created for the process. No buffer is required for this option. It is used by InternetSetOption.
    INTERNET_OPTION_DISABLE_AUTODIAL        : Not currently implemented.
    INTERNET_OPTION_DISCONNECTED_TIMEOUT    : Not currently implemented.
    INTERNET_OPTION_END_BROWSER_SESSION     : Flushes entries not in use from the password cache on the hard drive. Also resets the cache time used when the synchronization mode is once-per-session. No buffer is required for this option. This is used by InternetSetOption.
    INTERNET_OPTION_ERROR_MASK              : Sets an unsigned long integer value that contains the error masks that can be handled by the client application. This can be a combination of the following values:
    INTERNET_ERROR_MASK_COMBINED_SEC_CERT   : Indicates that the client application can handle security certificate error codes.
    INTERNET_ERROR_MASK_INSERT_CDROM        : Indicates that the client application can handle the ERROR_INTERNET_INSERT_CDROM error code.
    INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY : Indicates that the client application can handle the ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY error code.
    INTERNET_ERROR_MASK_NEED_MSN_SSPI_PKG   : Not currently implemented.
    INTERNET_OPTION_EXTENDED_ERROR          : Retrieves an unsigned long integer value that contains a Microsoft Windows® Sockets error code that was mapped to the ERROR_INTERNET_ error messages last returned in this thread context. This option is used on a NULLHINTERNET handle by InternetQueryOption.
    INTERNET_OPTION_FROM_CACHE_TIMEOUT      : Sets or retrieves an unsigned long integer value that contains the amount of time the system should wait for a response to a network request before checking the cache for a copy of the resource. If a network request takes longer than the time specified and the requested resource is available in the cache, the resource will be retrieved from the cache. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_HANDLE_TYPE             : Retrieves an unsigned long integer value that contains the type of the HINTERNET handles passed in. This is used by InternetQueryOption on any HINTERNET handle. Possible return values include:
      INTERNET_HANDLE_TYPE_CONNECT_FTP 
      INTERNET_HANDLE_TYPE_CONNECT_GOPHER 
      INTERNET_HANDLE_TYPE_CONNECT_HTTP
      INTERNET_HANDLE_TYPE_FILE_REQUEST 
      INTERNET_HANDLE_TYPE_FTP_FILE 
      INTERNET_HANDLE_TYPE_FTP_FILE_HTML 
      INTERNET_HANDLE_TYPE_FTP_FIND
      INTERNET_HANDLE_TYPE_FTP_FIND_HTML
      INTERNET_HANDLE_TYPE_GOPHER_FILE :
      INTERNET_HANDLE_TYPE_GOPHER_FILE_HTML 
      INTERNET_HANDLE_TYPE_GOPHER_FIND 
      INTERNET_HANDLE_TYPE_GOPHER_FIND_HTML 
      INTERNET_HANDLE_TYPE_HTTP_REQUEST
      INTERNET_HANDLE_TYPE_INTERNET

    INTERNET_OPTION_HTTP_VERSION             : Sets or retrieves an HTTP_VERSION_INFO structure that contains the HTTP version being supported. This must be used on a NULL handle. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_IDLE_STATE               : Not currently implemented.
    INTERNET_OPTION_IGNORE_OFFLINE           : Sets or retrieves whether the global offline flag should be ignored. No buffer is required for this option. This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    INTERNET_OPTION_KEEP_CONNECTION          : Not currently implemented.
    INTERNET_OPTION_LISTEN_TIMEOUT           : Not currently implemented.
    INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER : Sets or retrieves an unsigned long integer value that contains the maximum number of connections allowed per HTTP/1.0 server. This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    INTERNET_OPTION_MAX_CONNS_PER_SERVER     : Sets or retrieves an unsigned long integer value that contains the maximum number of connections allowed per server. This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    INTERNET_OPTION_OFFLINE_MODE             : Not currently implemented.
    INTERNET_OPTION_OFFLINE_SEMANTICS        : Not currently implemented.
    INTERNET_OPTION_PARENT_HANDLE            : Retrieves the parent handle to this handle. This option can be used on any HINTERNET handle by InternetQueryOption.
    INTERNET_OPTION_PASSWORD                 : Sets or retrieves a string value that contains the password associated with a handle returned by InternetConnect. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_PER_CONNECTION_OPTION    : Sets or retrieves an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection. This is used by InternetQueryOption and InternetSetOption. This option is only valid in Internet Explorer 5 and later.
    INTERNET_OPTION_POLICY                   : Not currently implemented.
    INTERNET_OPTION_PROXY                    : Sets or retrieves an INTERNET_PROXY_INFO structure that contains the proxy information on an existing InternetOpen handle when the HINTERNET handle is not NULL. If the HINTERNET handle is NULL, the function sets or queries the global proxy information. This option can be used on the HINTERNET handle returned by InternetOpen. It is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_PROXY_PASSWORD           : Sets or retrieves a string value that contains the password currently being used to access the proxy. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_PROXY_USERNAME           : Sets or retrieves a string value that contains the user name currently being used to access the proxy. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_READ_BUFFER_SIZE         : Sets or retrieves an unsigned long integer value that contains the size of the read buffer. This option can be used on HINTERNET handles returned by FtpOpenFile, FtpFindFirstFile, and InternetConnect (FTP session only). This option is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_RECEIVE_THROUGHPUT       : Not currently implemented.
    INTERNET_OPTION_RECEIVE_TIMEOUT          : Sets or retrieves an unsigned long integer value that contains the time-out value, in milliseconds, to receive a response to a request. If the response takes longer than this time-out value, the request is canceled. This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_REFRESH                  : Causes the proxy information to be reread from the registry for a handle. No buffer is required. This option can be used on the HINTERNET handle returned by InternetOpen. It is used by InternetSetOption.
    INTERNET_OPTION_REQUEST_FLAGS            : Retrieves an unsigned long integer value that contains the special status flags that indicate the status of the download currently in progress. This is used by InternetQueryOption. The INTERNET_OPTION_REQUEST_FLAGS option can be one of the following values:
    INTERNET_REQFLAG_ASYNC                   : Not currently implemented.
    INTERNET_REQFLAG_CACHE_WRITE_DISABLED    : Internet request cannot be cached (an HTTPS request, for example).
    INTERNET_REQFLAG_FROM_CACHE              : Response came from the cache.
    INTERNET_REQFLAG_NET_TIMEOUT             : Internet request timed out.
    INTERNET_REQFLAG_NO_HEADERS              : Original response contained no headers.
    INTERNET_REQFLAG_PASSIVE                 : Not currently implemented.
    INTERNET_REQFLAG_VIA_PROXY               : Request was made through a proxy.
    INTERNET_OPTION_REQUEST_PRIORITY         : Sets or retrieves an unsigned long integer value that contains the priority of requests competing for a connection on an HTTP handle. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_RESET_URLCACHE_SESSION   : Starts a new cache session for the process. No buffer is required. This is used by InternetSetOption.
    INTERNET_OPTION_SECONDARY_CACHE_KEY      : Sets or retrieves a string value that contains the secondary cache key. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_SECURITY_CERTIFICATE     : Retrieves the certificate for an SSL/PCT (Secure Sockets Layer/Private Communications Technology) server into a formatted string. This is used by InternetQueryOption.
    INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT : Retrieves the certificate for an SSL/PCT server into the INTERNET_CERTIFICATE_INFO structure. This is used by InternetQueryOption.
    INTERNET_OPTION_SECURITY_FLAGS           : Retrieves an unsigned long integer value that contains the security flags for a handle. This option is used by InternetQueryOption. It can be a combination of these values:
    SECURITY_FLAG_128BIT                     : Identical to the preferred value SECURITY_FLAG_STRENGTH_STRONG. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_40BIT                      : Identical to the preferred value SECURITY_FLAG_STRENGTH_WEAK. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_56BIT                      : Identical to the preferred value SECURITY_FLAG_STRENGTH_MEDIUM. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_FORTEZZ A                  : Indicates Fortezza has been used to provide secrecy, authentication, and/or integrity for the specified connection.
    SECURITY_FLAG_IETFSSL4                   : Not currently implemented.
    SECURITY_FLAG_IGNORE_CERT_CN_INVALID     : Ignores the ERROR_INTERNET_SEC_CERT_CN_INVALID error message.
    SECURITY_FLAG_IGNORE_CERT_DATE_INVALID   : Ignores the ERROR_INTERNET_SEC_CERT_DATE_INVALID error message.
    SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTP    : Ignores the ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR error message.
    SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS   : Ignores the ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR error message.
    SECURITY_FLAG_IGNORE_REVOCATION          : Ignores certificate revocation problems.
    SECURITY_FLAG_IGNORE_UNKNOWN_CA          : Ignores unknown certificate authority problems.
    SECURITY_FLAG_IGNORE_WRONG_USAGE         : Ignores incorrect usage problems.
    SECURITY_FLAG_NORMALBITNESS              : Identical to the value SECURITY_FLAG_STRENGTH_WEAK. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_PCT                        : Not currently implemented.
    SECURITY_FLAG_PCT4                       : Not currently implemented.
    SECURITY_FLAG_SECURE                     : Uses secure transfers. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_SSL                        : Not currently implemented.
    SECURITY_FLAG_SSL3                       : Not currently implemented.
    SECURITY_FLAG_STRENGTH_MEDIUM            : Uses medium (56-bit) encryption. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_STRENGTH_STRONG            : Uses strong (128-bit) encryption. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_STRENGTH_WEAK              : Uses weak (40-bit) encryption. This is only returned in a call to InternetQueryOption.
    SECURITY_FLAG_UNKNOWNBIT                 : The bit size used in the encryption is unknown. This is only returned in a call to InternetQueryOption.
    INTERNET_OPTION_SECURITY_KEY_BITNESS     : Retrieves an unsigned long integer value that contains the bit size of the encryption key. The larger the number, the greater the encryption strength being used. This is used by InternetQueryOption.
    INTERNET_OPTION_SEND_THROUGHPUT          : Not currently implemented.
    INTERNET_OPTION_SEND_TIMEOUT             : Sets or retrieves an unsigned long integer value that contains the time-out value to send a request. Units are in milliseconds. If the send takes longer than this time-out value, the send is canceled. This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_SETTINGS_CHANGED         : Informs the system that the registry settings have been changed so that it will check the settings on the next call to InternetConnect. This is used by InternetSetOption.
    INTERNET_OPTION_URL                      : Retrieves a string value that contains the full URL of a downloaded resource. If the original URL contained any extra information (such as search strings or anchors), or if the call was redirected, the URL returned will differ from the original. This option is valid on HINTERNET handles returned by InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest. It is used by InternetQueryOption.
    INTERNET_OPTION_USER_AGENT               : Sets or retrieves the user agent string on handles supplied by InternetOpen and used in subsequent HttpSendRequest functions, as long as it is not overridden by a header added by HttpAddRequestHeaders or HttpSendRequest. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_USERNAME                 : Sets or retrieves a string that contains the user name associated with a handle returned by InternetConnect. This is used by InternetQueryOption and InternetSetOption.
    INTERNET_OPTION_VERSION                  : Retrieves an INTERNET_VERSION_INFO structure that contains the version number of Wininet.dll. This option can be used on a NULLHINTERNET handle by InternetQueryOption.
    INTERNET_OPTION_WRITE_BUFFER_SIZE        : Sets or retrieves an unsigned long integer value that contains the size of the write buffer. This option can be used on HINTERNET handles returned by FtpOpenFile and InternetConnect (FTP session only). It is used by InternetQueryOption and InternetSetOption.
  }

  TINETApi_Options = class (TPersistent)
  private
    fOwner    : TCustomInternetComponent;
    fErrorMask: dword;
  protected
    function  getHandle:HINTERNET;virtual;
    procedure getPtrOption(option:dword;BufferToGet:pointer);virtual;
    procedure setPtrOption(option:dword;BufferToSet:pointer);virtual;
    function  getIntOption(option:dword):dword;virtual;
    procedure setIntOption(option:dword;aValue:dword);virtual;
    function  getBoolOption(option:dword):boolean;virtual;
    procedure setBoolOption(option:dword;aValue:boolean);virtual;
    function  getStrOption(option:dword):string;virtual;
    procedure setStrOption(option:dword;aValue:string);virtual;
    function  getASYNC:boolean;                    // Not currently implemented by MS-INET API.
    procedure setASYNC(p:boolean);                 // Not currently implemented by MS-INET API.
    function  getASYNC_ID:string;                  // Not implemented by MS-INET API.
    procedure setASYNC_ID(p:string);               // Not implemented by MS-INET API.
    function  getASYNC_PRIORITY:dword;             // Not currently implemented by MS-INET API.
    procedure setASYNC_PRIORITY(p:dword);          // Not currently implemented by MS-INET API.
    function  getBYPASS_EDITED_ENTRY:boolean;      // Gets INTERNET_OPTION_BYPASS_EDITED_ENTRY option.
    procedure setBYPASS_EDITED_ENTRY(p:boolean);   // Sets INTERNET_OPTION_BYPASS_EDITED_ENTRY option.
    function  getCACHE_STREAM_HANDLE:dword;        // No longer supported by MS-INET API.
    procedure setCACHE_STREAM_HANDLE(p:dword);     // No longer supported by MS-INET API.
    function  getCACHE_TIMESTAMPS:INTERNET_CACHE_TIMESTAMPS;    //Gets INTERNET_OPTION_CACHE_TIMESTAMPS option.
    procedure setCACHE_TIMESTAMPS(p:INTERNET_CACHE_TIMESTAMPS); //Sets INTERNET_OPTION_CACHE_TIMESTAMPS option.
    function  getCACHE_Expires:TDatetime;          // Gets ftExpires part of CACHE_TIMESTAMPS
    procedure setCACHE_Expires(p:TDateTime);       // Sets ftExpires part of CACHE_TIMESTAMPS
    function  getCACHE_LastModified:TDatetime;     // Gets ftLastModified part of CACHE_TIMESTAMPS
    procedure setCACHE_LastModified(p:TDatetime);  // Sets ftLastModified part of CACHE_TIMESTAMPS
    function  getCALLBACK:INTERNET_STATUS_CALLBACK;     // Retrieves the address of the callback function defined for this handle.
    procedure setCALLBACK(p:INTERNET_STATUS_CALLBACK);  // Sets the address of the callback function defined for this handle.
    function  getCALLBACK_FILTER:dword;            // Not currently implemented by MS-INET API.
    procedure setCALLBACK_FILTER(p:dword);         // Not currently implemented by MS-INET API.
    function  getCODEPAGE:string;                  // Not currently implemented by MS-INET API.
    procedure setCODEPAGE(p:string);               // Not currently implemented by MS-INET API.
    function  getCONNECT_RETRIES:dword;            // Retrieves INTERNET_OPTION_CONNECT_RETRIES option. See "CONNECT_RETRIES" property declaration for more information.
    procedure setCONNECT_RETRIES(p:dword);         // Sets INTERNET_OPTION_CONNECT_RETRIES option. See "CONNECT_RETRIES" property declaration for more information.
    function  getCONNECT_TIMEOUT:dword;            // Retrieves INTERNET_OPTION_CONNECT_TIMEOUT option. see "CONNECT_TIMEOUT" property declaration for more information.
    procedure setCONNECT_TIMEOUT(p:dword);         // Sets INTERNET_OPTION_CONNECT_TIMEOUT option. see "CONNECT_TIMEOUT" property declaration for more information.
    function  getCONNECTED_STATE:dword;            // Retrieves INTERNET_OPTION_CONNECTED_STATE option. see "CONNECTED_STATE" property declaration for more information.
    procedure setCONNECTED_STATE(p:dword);         // Sets INTERNET_OPTION_CONNECTED_STATE option. see "CONNECTED_STATE" property declaration for more information.
    function  getCONTEXT_VALUE:pointer;            // Retrieves INTERNET_OPTION_CONTEXT_VALUE option. see "CONTEXT_VALUE" property declaration for more information.
    procedure setCONTEXT_VALUE(p:pointer);         // Sets INTERNET_OPTION_CONTEXT_VALUE option. see "CONTEXT_VALUE" property for declaration more information.
    function  getCONTROL_RECEIVE_TIMEOUT:dword;    // Retrieves INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
    procedure setCONTROL_RECEIVE_TIMEOUT(p:dword); // Sets INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
    function  getCONTROL_SEND_TIMEOUT:dword;       // Retrieves INTERNET_OPTION_CONTROL_SEND_TIMEOUT option. see "CONTROL_SEND_TIMEOUT" property declaration for more information.
    procedure setCONTROL_SEND_TIMEOUT(p:dword);    // Gets INTERNET_OPTION_CONTROL_SEND_TIMEOUT option. see "CONTROL_SEND_TIMEOUT" property declaration for more information.
    function  getDATA_RECEIVE_TIMEOUT:dword;       // Not implemented by MS-INET API.
    procedure setDATA_RECEIVE_TIMEOUT(p:dword);    // Not implemented by MS-INET API.
    function  getDATA_SEND_TIMEOUT:dword;          // Not implemented by MS-INET API.
    procedure setDATA_SEND_TIMEOUT(p:dword);       // Not implemented by MS-INET API.
    function  getDATAFILE_NAME:string;             // Retrieves INTERNET_OPTION_DATAFILE_NAME option. see "DATAFILE_NAME" property declaration for more information.
    procedure setDATAFILE_NAME(p:string);          // Gets INTERNET_OPTION_DATAFILE_NAME option. see "DATAFILE_NAME" property declaration for more information.
    function  getDISABLE_AUTODIAL:boolean;         // Not currently implemented by MS-INET API.
    procedure setDISABLE_AUTODIAL(p:boolean);      // Not currently implemented by MS-INET API.
    function  getDISCONNECTED_TIMEOUT:dword;       // Not currently implemented by MS-INET API.
    procedure setDISCONNECTED_TIMEOUT(p:dword);    // Not currently implemented by MS-INET API.
    function  getERROR_MASK:dword;                 // Retrieves INTERNET_OPTION_ERROR_MASK option. see "ERROR_MASK" property declaration for more information.
    //need to use local copy for getERROR_MASK!!!
    procedure setERROR_MASK(p:dword);              // Sets INTERNET_OPTION_ERROR_MASK option. see "ERROR_MASK" property declaration for more information.
    function  get_is_error_mask_COMBINED_SEC_CERT:boolean;      //Retrieves "COMBINED_SEC_CERT" flag of "ERROR_MASK" property.
    procedure set_is_error_mask_COMBINED_SEC_CERT(p:boolean);   //Sets "COMBINED_SEC_CERT" flag of "ERROR_MASK" property.
    function  get_is_error_mask_INSERT_CDROM:boolean;           //Retrieves "INSERT_CDROM" flag of "ERROR_MASK" property.
    procedure set_is_error_mask_INSERT_CDROM(p:boolean);        //Sets "INSERT_CDROM" flag of "ERROR_MASK" property.
    function  get_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY:boolean;    //Retrieves "LOGIN_FAILURE_DISPLAY_ENTITY_BODY" flag of "ERROR_MASK" property.
    procedure set_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY(p:boolean); //Sets "LOGIN_FAILURE_DISPLAY_ENTITY_BODY" flag of "ERROR_MASK" property.
    function  get_is_error_mask_NEED_MSN_SSPI_PKG:boolean;                    //Retrieves "NEED_MSN_SSPI_PKG" flag of "ERROR_MASK" property.
    procedure set_is_error_mask_NEED_MSN_SSPI_PKG(p:boolean);                 //Sets "NEED_MSN_SSPI_PKG" flag of "ERROR_MASK" property.
    // Retrieves an unsigned long integer value that contains a Microsoft Windows® Sockets error code that was mapped to the ERROR_INTERNET_ error
    // messages last returned in this thread context. This option is used on a NULLHINTERNET handle by InternetQueryOption.
    function  getEXTENDED_ERROR:dword;             // Retrieves INTERNET_OPTION_EXTENDED_ERROR option.
    function  getFROM_CACHE_TIMEOUT:dword;         // Retrieves INTERNET_OPTION_FROM_CACHE_TIMEOUT option. see "FROM_CACHE_TIMEOUT" property declaration for more information.
    procedure setFROM_CACHE_TIMEOUT(p:dword);      // Sets INTERNET_OPTION_FROM_CACHE_TIMEOUT option. see "FROM_CACHE_TIMEOUT" property declaration for more information.
    function  getHANDLE_TYPE:TInternetHandleTypes; // Retrieves current type of internet handle.
    function  getHTTP_VERSION:HTTP_VERSION_INFO;      // Retrieves INTERNET_OPTION_HTTP_VERSION option. see "HTTP_VERSION" property declaration for more information.
    procedure setHTTP_VERSION(p:HTTP_VERSION_INFO);   // Sets INTERNET_OPTION_HTTP_VERSION option. see "HTTP_VERSION" property declaration for more information.
    function  getIGNORE_OFFLINE:boolean;           // Retrieves INTERNET_OPTION_IGNORE_OFFLINE option. see "IGNORE_OFFLINE" property declaration for more information.
    procedure setIGNORE_OFFLINE(p:boolean);        // Sets INTERNET_OPTION_IGNORE_OFFLINE option. see "IGNORE_OFFLINE" property declaration for more information.
    function  getKEEP_CONNECTION:boolean;           // Not currently implemented by MS-INET API.
    procedure setKEEP_CONNECTION(p:boolean);       // Not currently implemented by MS-INET API.
    function  getLISTEN_TIMEOUT:dword;             // Not currently implemented by MS-INET API.
    procedure setLISTEN_TIMEOUT(p:dword);          // Not currently implemented by MS-INET API.
    function  getMAX_CONNS_PER_1_0_SERVER:dword;   // Retrieves INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER option. see "MAX_CONNS_PER_1_0_SERVER" property declaration for more information.
    procedure setMAX_CONNS_PER_1_0_SERVER(p:dword);// Sets INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER option. see "MAX_CONNS_PER_1_0_SERVER" property declaration for more information.
    function  getMAX_CONNS_PER_SERVER:dword;       // Retrieves INTERNET_OPTION_MAX_CONNS_PER_SERVER option. see "MAX_CONNS_PER_SERVER" property declaration for more information.
    procedure setMAX_CONNS_PER_SERVER(p:dword);    // Sets INTERNET_OPTION_MAX_CONNS_PER_SERVER option. see "MAX_CONNS_PER_SERVER" property declaration for more information.
    function  getOFFLINE_MODE:boolean;             // Not currently implemented by MS-INET API.
    procedure setOFFLINE_MODE(p:boolean);          // Not currently implemented by MS-INET API.
    function  getPARENT_HANDLE:HINTERNET;          // Retrieves the parent handle to this handle. This option can be used on any HINTERNET handle by InternetQueryOption.
    function  getPASSWORD:string;                  // Retrieves a string value that contains the password associated with a handle returned by InternetConnect.
    procedure setPASSWORD(p:string);               // Sets a string value that contains the password associated with a handle returned by InternetConnect.
    function  getPER_CONNECTION_OPTION: INTERNET_PER_CONN_OPTION_LIST;   // Retrieves an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection.
    procedure setPER_CONNECTION_OPTION(p:INTERNET_PER_CONN_OPTION_LIST); // Sets an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection.
    function  getPOLICY:dword;                     // Not currently implemented by MS-INET API.
    procedure setPOLICY(p:dword);                  // Not currently implemented by MS-INET API.
    function  getPROXY:INTERNET_PROXY_INFO;        // Retrieves INTERNET_OPTION_PROXY option. see "PROXY" property (public) declaration for more information.
    procedure setPROXY(p:INTERNET_PROXY_INFO);     // Sets INTERNET_OPTION_PROXY option. see "PROXY" property (public) declaration for more information.
    function  getPROXY_PASSWORD:string;            // Retrieves INTERNET_OPTION_PROXY_PASSWORD option. see "PROXY_PASSWORD" property declaration for more information.
    procedure setPROXY_PASSWORD(p:string);         // Sets INTERNET_OPTION_PROXY_PASSWORD option. see "PROXY_PASSWORD" property declaration for more information.
    function  getPROXY_USERNAME:string;            // Retrieves INTERNET_OPTION_PROXY_USERNAME option. see "PROXY_USERNAME" property declaration for more information.
    procedure setPROXY_USERNAME(p:string);         // Sets INTERNET_OPTION_PROXY_USERNAME option. see "PROXY_USERNAME" property declaration for more information.
    function  getREAD_BUFFER_SIZE:dword;           // Retrieves INTERNET_OPTION_READ_BUFFER_SIZE option. see "READ_BUFFER_SIZE" property declaration for more information.
    procedure setREAD_BUFFER_SIZE(p:dword);        // Sets INTERNET_OPTION_READ_BUFFER_SIZE option. see "READ_BUFFER_SIZE" property declaration for more information.
    function  getRECEIVE_TIMEOUT:dword;            // Retrieves INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
    procedure setRECEIVE_TIMEOUT(p:dword);         // Sets INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
    function  getREQUEST_FLAGS:dword;              // Retrieves INTERNET_OPTION_REQUEST_FLAGS option. see "REQUEST_FLAGS" property declaration for more information. See also is_req_* properties
    //The INTERNET_OPTION_REQUEST_FLAGS interpreters
    function  get_is_req_ASYNC:boolean;                   // Retrieves INTERNET_REQFLAG_ASYNC flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_CACHE_WRITE_DISABLED:boolean;    // Retrieves INTERNET_REQFLAG_CACHE_WRITE_DISABLED flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_FROM_CACHE:boolean;              // Retrieves INTERNET_REQFLAG_FROM_CACHE flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_NET_TIMEOUT:boolean;             // Retrieves INTERNET_REQFLAG_NET_TIMEOUT flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_NO_HEADERS:boolean;              // Retrieves INTERNET_REQFLAG_NO_HEADERS flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_PASSIVE:boolean;                 // Retrieves INTERNET_REQFLAG_PASSIVE flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  get_is_req_VIA_PROXY:boolean;               // Retrieves INTERNET_REQFLAG_VIA_PROXY flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
    function  getREQUEST_PRIORITY:dword;                  // Retrieves INTERNET_OPTION_REQUEST_PRIORITY option. see "REQUEST_PRIORITY" property declaration for more information.
    procedure setREQUEST_PRIORITY(p:dword);               // Sets INTERNET_OPTION_REQUEST_PRIORITY option. see "REQUEST_PRIORITY" property declaration for more information.
    function  getSECONDARY_CACHE_KEY:string;              // Retrieves INTERNET_OPTION_SECONDARY_CACHE_KEY option. see "SECONDARY_CACHE_KEY" property declaration for more information.
    procedure setSECONDARY_CACHE_KEY(p:string);           // Sets INTERNET_OPTION_SECONDARY_CACHE_KEY option. see "SECONDARY_CACHE_KEY" property declaration for more information.
    function  getSECURITY_CERTIFICATE:string;             // Retrieves INTERNET_OPTION_SECURITY_CERTIFICATE option. see "SECURITY_CERTIFICATE" property declaration for more information.
    function  getSECURITY_CERTIFICATE_STRUCT:INTERNET_CERTIFICATE_INFO;  // Retrieves INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT option. see "SECURITY_CERTIFICATE_STRUCT" property declaration for more information.
    function  getSECURITY_FLAGS:dword;                    // Retrieves INTERNET_OPTION_SECURITY_FLAGS option. see "SECURITY_FLAGS" property declaration for more information. See also sec_is_* properties which indicate these flags as seperate boolean values.
    // INTERNET_OPTION_SECURITY_FLAGS interpreters (SECURITY_FLAG_*):
    function  get_sec_is_128BIT:boolean;                  // Identical to the preferred value STRENGTH_STRONG.
    function  get_sec_is_40BIT:boolean;                   // Identical to the preferred value STRENGTH_WEAK.
    function  get_sec_is_56BIT:boolean;                   // Identical to the preferred value STRENGTH_MEDIUM.
    function  get_sec_is_FORTEZZ_A:boolean;               // Indicates Fortezza has been used to provide secrecy, authentication, and/or integrity for the specified connection.
    function  get_sec_is_IETFSSL4:boolean;                // Not currently implemented.
    function  get_sec_is_IGNORE_CERT_CN_INVALID:boolean;  // Ignores the ERROR_INTERNET_SEC_CERT_CN_INVALID error message.
    function  get_sec_is_IGNORE_CERT_DATE_INVALID:boolean;// Ignores the ERROR_INTERNET_SEC_CERT_DATE_INVALID error message.
    function  get_sec_is_IGNORE_REDIRECT_TO_HTTP:boolean; // Ignores the ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR error message.
    function  get_sec_is_IGNORE_REDIRECT_TO_HTTPS:boolean;// Ignores the ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR error message.
    function  get_sec_is_IGNORE_REVOCATION:boolean;       // Ignores certificate revocation problems.
    function  get_sec_is_IGNORE_UNKNOWN_CA:boolean;       // Ignores unknown certificate authority problems.
    function  get_sec_is_IGNORE_WRONG_USAGE:boolean;      // Ignores incorrect usage problems.
    function  get_sec_is_NORMALBITNESS:boolean;           // Identical to the value property security_STRENGTH_WEAK.
    function  get_sec_is_PCT:boolean;                     // Not currently implemented.
    function  get_sec_is_PCT4:boolean;                    // Not currently implemented.
    function  get_sec_is_SECURE:boolean;                  // Uses secure transfers.
    function  get_sec_is_SSL:boolean;                     // Not currently implemented.
    function  get_sec_is_SSL3:boolean;                    // Not currently implemented.
    function  get_sec_is_STRENGTH_MEDIUM:boolean;         // Uses medium (56-bit) encryption.
    function  get_sec_is_STRENGTH_STRONG:boolean;         // Uses strong (128-bit) encryption.
    function  get_sec_is_STRENGTH_WEAK:boolean;           // Uses weak (40-bit) encryption.
    function  get_sec_is_UNKNOWNBIT:boolean;              // The bit size used in the encryption is unknown.
    function  getSECURITY_KEY_BITNESS:dword;              // Retrieves INTERNET_OPTION_SECURITY_KEY_BITNESS option. see "SECURITY_KEY_BITNESS" property declaration for more information.
    function  getSEND_TIMEOUT:dword;                      // Retrieves INTERNET_OPTION_SEND_TIMEOUT option. see "SEND_TIMEOUT" property declaration for more information.
    procedure setSEND_TIMEOUT(p:dword);                   // Sets INTERNET_OPTION_SEND_TIMEOUT option. see "SEND_TIMEOUT" property declaration for more information.
    function  getURL:string;                              // Retrieves INTERNET_OPTION_URL option. see "URL" property declaration for more information.
    function  getUSER_AGENT:string;                       // Retrieves INTERNET_OPTION_USER_AGENT option. see "USER_AGENT" property declaration for more information.
    procedure setUSER_AGENT(p:string);                    // Sets INTERNET_OPTION_USER_AGENT option. see "USER_AGENT" property declaration for more information.
    function  getUSERNAME:string;                         // Retrieves INTERNET_OPTION_USERNAME option. see "USERNAME" property declaration for more information.
    procedure setUSERNAME(p:string);                      // Sets INTERNET_OPTION_USERNAME option. see "USERNAME" property declaration for more information.
    function  getVERSION:INTERNET_VERSION_INFO;           // Retrieves INTERNET_OPTION_VERSION option. see "VERSION" property declaration for more information.
    function  getWRITE_BUFFER_SIZE:dword;                 // Retrieves INTERNET_OPTION_WRITE_BUFFER_SIZE option. see "WRITE_BUFFER_SIZE" property declaration for more information.
    procedure setWRITE_BUFFER_SIZE(p:dword);              // Sets INTERNET_OPTION_WRITE_BUFFER_SIZE option. see "WRITE_BUFFER_SIZE" property declaration for more information.
  public
     (******************************************* PUBLIC PROPERTIES ***********************************************************)
    property Owner:TCustomInternetComponent read fOwner;
    // Not currently implemented by MS-INET API.
    property ASYNC : boolean read getASYNC write setASYNC;
    // Not implemented by MS-INET API.
    property ASYNC_ID : string read getASYNC_ID write setASYNC_ID;
    // Not currently implemented by MS-INET API.
    property ASYNC_PRIORITY :dword read getASYNC_PRIORITY write setASYNC_PRIORITY;
    // No longer supported by MS-INET API.
    property CACHE_STREAM_HANDLE : dword read getCACHE_STREAM_HANDLE write setCACHE_STREAM_HANDLE;
    // Not currently implemented by MS-INET API.
    property CALLBACK_FILTER :dword read getCALLBACK_FILTER write setCALLBACK_FILTER;

    // Retrieves an INTERNET_CACHE_TIMESTAMPS structure that contains the LastModified time and Expires time from the resource stored in
    // the Internet cache. This value is used by InternetQueryOption.
    // See also CACHE_Expires and CACHE_LastModified published properties which are more easy to use.
    property CACHE_TIMESTAMPS:INTERNET_CACHE_TIMESTAMPS read getCACHE_TIMESTAMPS write setCACHE_TIMESTAMPS;
    // Sets or retrieves the address of the callback function defined for this handle. This option can be used on all HINTERNET handles.
    // Used by InternetQueryOption and InternetSetOption.
    property CALLBACK :INTERNET_STATUS_CALLBACK read getCALLBACK write setCALLBACK;

    // Not currently implemented by MS-INET API.
    property CODEPAGE: string read getCODEPAGE write setCODEPAGE;

    // Sets or retrieves a DWORD_PTR that contains the address of the context value associated with this HINTERNET handle.
    // This option can be used on any HINTERNET handle. This is used by InternetQueryOption and InternetSetOption.
    // Previously, this set the context value to the address stored in the DWORD(lpBuffer) pointer.
    // This has been corrected so that the value stored in the buffer will be used and
    // the INTERNET_OPTION_CONTEXT_VALUE flag will be assigned a new value. The old value, 10, has been preserved so that
    // applications written for the old behavior are still supported.
    property CONTEXT_VALUE :pointer read getCONTEXT_VALUE write setCONTEXT_VALUE;

    // Not implemented by MS-INET API.
    property DATA_RECEIVE_TIMEOUT: dword read getDATA_RECEIVE_TIMEOUT write setDATA_RECEIVE_TIMEOUT;

    // Not implemented by MS-INET API.
    property DATA_SEND_TIMEOUT: dword read getDATA_SEND_TIMEOUT write setDATA_SEND_TIMEOUT;

    // Not implemented by MS-INET API.
    property DISABLE_AUTODIAL: boolean read getDISABLE_AUTODIAL write setDISABLE_AUTODIAL;

    // Not currently implemented by MS-INET API.
    property DISCONNECTED_TIMEOUT: dword read getDISCONNECTED_TIMEOUT write setDISCONNECTED_TIMEOUT;

    // Internet Handle that is all these options belong to
    property Handle: HINTERNET read getHandle;
    // Not currently implemented.
    (* property IDLE_STATE *)

    // Not currently implemented b MS-INET API.
    property KEEP_CONNECTION: boolean read getKEEP_CONNECTION write setKEEP_CONNECTION;

    // Not currently implemented.
    property LISTEN_TIMEOUT: dword read  getLISTEN_TIMEOUT write setLISTEN_TIMEOUT;

    // Not currently implemented by MS-INET API.
    property OFFLINE_MODE: boolean read getOFFLINE_MODE write setOFFLINE_MODE;

    (* property OFFLINE_SEMANTICS *)       // Not currently implemented.
    // Retrieves the parent handle to this handle. This option can be used on any HINTERNET handle by InternetQueryOption.
    property PARENT_HANDLE: HINTERNET read getPARENT_HANDLE;

    // Sets or retrieves an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection.
    // This is used by InternetQueryOption and InternetSetOption. This option is only valid in Internet Explorer 5 and later.
    property PER_CONNECTION_OPTION:INTERNET_PER_CONN_OPTION_LIST read getPER_CONNECTION_OPTION write setPER_CONNECTION_OPTION;

    // Not currently implemented by MS-INET API.
    property POLICY:dword read getPOLICY write setPOLICY;

    // Sets or retrieves an INTERNET_PROXY_INFO structure that contains the proxy information on an existing InternetOpen handle
    // when the HINTERNET handle is not NULL. If the HINTERNET handle is NULL, the function sets or queries the global proxy information.
    // This option can be used on the HINTERNET handle returned by InternetOpen. It is used by InternetQueryOption and InternetSetOption.
    property PROXY: INTERNET_PROXY_INFO read getPROXY write setPROXY;

    (* property RECEIVE_THROUGHPUT *)       // Not currently implemented.Datatype unknown!

    // Retrieves the certificate for an SSL/PCT server into the INTERNET_CERTIFICATE_INFO structure. This is used by InternetQueryOption.
    property SECURITY_CERTIFICATE_STRUCT: INTERNET_CERTIFICATE_INFO read getSECURITY_CERTIFICATE_STRUCT;

    (* property SEND_THROUGHPUT *)          // Not currently implemented. Unknown Datatype!

    (******************************************* PUBLIC METHODS ***********************************************************)

    // Causes the system to log off the Digest authentication SSPI package, purging all of the credentials created for the process.
    // No buffer is required for this option. It is used by InternetSetOption.
    function DIGEST_AUTH_UNLOAD:boolean;

    // Flushes entries not in use from the password cache on the hard drive. Also resets the cache time used
    // when the synchronization mode is once-per-session. No buffer is required for this option.
    // This is used by InternetSetOption.
    function END_BROWSER_SESSION:boolean;

    // Causes the proxy information to be reread from the registry for a handle. No buffer is required.
    // This option can be used on the HINTERNET handle returned by InternetOpen. It is used by InternetSetOption.
    // ORGINAL option is INTERNET_OPTION_REFRESH!!!
    function REFRESH_PROXY_INFO:boolean;

    // Starts a new cache session for the process.
    // required option value is INTERNET_OPTION_RESET_URLCACHE_SESSION for InternetSetOption
    function RESET_URLCACHE_SESSION:boolean;

    //Informs the system that the registry settings have been changed so that it will check the settings on the next call to InternetConnect.
    function SETTINGS_CHANGED:boolean;

    constructor Create(aOwner:TCustomInternetComponent);
    destructor  destroy;override;
  published

    // Sets or retrieves the Boolean value that determines if the system should check the network for newer content and
    // overwrite edited cache entries if a newer version is found. If set to TRUE, the system will check the network for
    // newer content and overwrite the edited cache entry with the newer version.
    // The default is FALSE, which indicates that the edited cache entry should be used without checking the network.
    // This is used by InternetQueryOption and InternetSetOption. It is valid only in Microsoft® Internet Explorer 5 and later.
    property BYPASS_EDITED_ENTRY :boolean read getBYPASS_EDITED_ENTRY write setBYPASS_EDITED_ENTRY;

    //Sets or retieves ftExpires part of CACHE_TIMESTAMPS public property
    property CACHE_Expires:TDatetime      read getCACHE_Expires write setCACHE_Expires;

    //Sets or retieves ftLastModified part of CACHE_TIMESTAMPS public property
    property CACHE_LastModified:TDatetime read getCACHE_LastModified write setCACHE_LastModified;

    // This flag is not supported by InternetQueryOption. The LPVOID(lpBuffer) parameter must be a pointer to a CERT CONTEXT structure and
    // not a pointer to a CERT CONTEXT pointer. If an application receives ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED,
    // it must call InternetErrorDlg or use InternetSetOption to supply a certificate before retrying the request.
    // CertDuplicateCertificateContext is then called so that the certificate context passed can be independently released by the application.
    {* property CLIENT_CERT_CONTEXT *} //There is no reference Information.Will be implemented when info available from microsoft...


    {* property CONNECT_BACKOFF *} // Not currently implemented by MS-INET API.

    // Sets or retrieves an unsigned long integer value that contains the number of times Microsoft Win32® Internet (WinInet) will attempt to
    // resolve and connect to a host. WinInet will only attempt once per IP address. For example, if you attempt to connect to a multihome host
    // that has ten IP addresses and INTERNET_OPTION_CONNECT_RETRIES is set to seven, WinInet will only attempt to resolve and connect to
    // the first seven IP address. Conversely, given the same set of ten IP addresses, if INTERNET_OPTION_CONNECT_RETRIES is set to 20
    // WinInet will attempt each of the ten only once.
    // If a host has only one IP address and the first connection attempt fails, there will be no further attempts.
    // If a connection attempt still fails after the specified number of attempts, the request is canceled. The default value for
    // INTERNET_OPTION_CONNECT_RETRIES is five attempts. This option can be used on any HINTERNET handle, including a NULL handle.
    // It is used by InternetQueryOption and InternetSetOption
    property CONNECT_RETRIES: dword read getCONNECT_RETRIES write setCONNECT_RETRIES;

    {* property CONNECT_TIME *} // Not currently implemented by MS-INET API.

    // Sets or retrieves an unsigned long integer value that contains the time-out value to use for Internet connection requests.
    // Units are in milliseconds. If a connection request takes longer than this time-out value, the request is canceled.
    // When attempting to connect to multiple IP addresses for a single host (a multihome host), the timeout limit is cumulative for
    // all of the IP addresses. This option can be used on any HINTERNET handle, including a NULL handle.
    // It is used by InternetQueryOption and InternetSetOption.
    property CONNECT_TIMEOUT: dword read getCONNECT_TIMEOUT write setCONNECT_TIMEOUT;

    // Sets or retrieves an unsigned long integer value that contains the connected state.
    // This is used by InternetQueryOption and InternetSetOption.
    property CONNECTED_STATE: dword read getCONNECTED_STATE write setCONNECTED_STATE;

    // Identical to INTERNET_OPTION_RECEIVE_TIMEOUT. This is used by InternetQueryOption and InternetSetOption.
    property CONTROL_RECEIVE_TIMEOUT: dword read getCONTROL_RECEIVE_TIMEOUT write setCONTROL_RECEIVE_TIMEOUT;

    // Identical to INTERNET_OPTION_SEND_TIMEOUT. This is used by InternetQueryOption and InternetSetOption.
    property CONTROL_SEND_TIMEOUT: dword read getCONTROL_SEND_TIMEOUT write setCONTROL_SEND_TIMEOUT;

    // Retrieves a string value that contains the name of the file backing a downloaded entity.
    // This flag is valid after InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest has completed.
    // It is used by InternetQueryOption and InternetSetOption.
    property DATAFILE_NAME: string read getDATAFILE_NAME write setDATAFILE_NAME;

    // Sets an unsigned long integer value that contains the error masks that can be handled by the client application.
    property ERROR_MASK: dword read getERROR_MASK write setERROR_MASK;
    // ERROR_MASK can be a combination of the following values:

      // Indicates that the client application can handle security certificate error codes.
      property is_error_mask_COMBINED_SEC_CERT: boolean read get_is_error_mask_COMBINED_SEC_CERT write set_is_error_mask_COMBINED_SEC_CERT;

      // Indicates that the client application can handle the ERROR_INTERNET_INSERT_CDROM error code.
      property is_error_mask_INSERT_CDROM: boolean read get_is_error_mask_INSERT_CDROM write set_is_error_mask_INSERT_CDROM;

      // Indicates that the client application can handle the ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY error code.
      property is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY: boolean read get_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY write set_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY;

      // Not currently implemented.
      property is_error_mask_NEED_MSN_SSPI_PKG:boolean read get_is_error_mask_NEED_MSN_SSPI_PKG write set_is_error_mask_NEED_MSN_SSPI_PKG;

    // Retrieves an unsigned long integer value that contains a Microsoft Windows® Sockets error code that was mapped to the ERROR_INTERNET_ error
    // messages last returned in this thread context. This option is used on a NULLHINTERNET handle by InternetQueryOption.
    property EXTENDED_ERROR: dword read getEXTENDED_ERROR;

    // Sets or retrieves an unsigned long integer value that contains the amount of time the system should wait for a response to
    // a network request before checking the cache for a copy of the resource. If a network request takes longer than the time specified and
    // the requested resource is available in the cache, the resource will be retrieved from the cache.
    // This is used by InternetQueryOption and InternetSetOption.
    property FROM_CACHE_TIMEOUT: dword read getFROM_CACHE_TIMEOUT write setFROM_CACHE_TIMEOUT;

    // Retrieves an unsigned long integer value that contains the type of the HINTERNET handles passed in.
    // This is used by InternetQueryOption on any HINTERNET handle.
    property HANDLE_TYPE:TInternetHandleTypes read getHANDLE_TYPE;

    // Sets or retrieves an HTTP_VERSION_INFO structure that contains the HTTP version being supported.
   // This must be used on a NULL handle. This is used by InternetQueryOption and InternetSetOption.
    property HTTP_VERSION:HTTP_VERSION_INFO read getHTTP_VERSION write setHTTP_VERSION;

    // Sets or retrieves whether the global offline flag should be ignored. No buffer is required for this option.
    // This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    property IGNORE_OFFLINE: boolean read getIGNORE_OFFLINE write setIGNORE_OFFLINE;
    
    // Sets or retrieves an unsigned long integer value that contains the maximum number of connections allowed per HTTP/1.0 server.
    // This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    property MAX_CONNS_PER_1_0_SERVER: dword read getMAX_CONNS_PER_1_0_SERVER write setMAX_CONNS_PER_1_0_SERVER;

    // Sets or retrieves an unsigned long integer value that contains the maximum number of connections allowed per server.
    // This is used by InternetQueryOption and InternetSetOption. This value was introduced in Internet Explorer 5.
    property MAX_CONNS_PER_SERVER: dword read getMAX_CONNS_PER_SERVER write setMAX_CONNS_PER_SERVER;

    // Sets or retrieves a string value that contains the password associated with a handle returned by InternetConnect.
    // This is used by InternetQueryOption and InternetSetOption.
    property PASSWORD: string read getPASSWORD write setPASSWORD;

    // Sets or retrieves a string value that contains the password currently being used to access the proxy.
    // This is used by InternetQueryOption and InternetSetOption.
    property PROXY_PASSWORD: string read getPROXY_PASSWORD write setPROXY_PASSWORD;
    // Sets or retrieves a string value that contains the user name currently being used to access the proxy.
    // This is used by InternetQueryOption and InternetSetOption.
    property PROXY_USERNAME: string read getPROXY_USERNAME write setPROXY_USERNAME;
    // Sets or retrieves an unsigned long integer value that contains the size of the read buffer.
    // This option can be used on HINTERNET handles returned by FtpOpenFile, FtpFindFirstFile, and InternetConnect (FTP session only).
    // This option is used by InternetQueryOption and InternetSetOption.
    property READ_BUFFER_SIZE: dword read getREAD_BUFFER_SIZE write setREAD_BUFFER_SIZE;

    // Sets or retrieves an unsigned long integer value that contains the time-out value, in milliseconds, to receive a response to a request.
    // If the response takes longer than this time-out value, the request is canceled.
    // This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption.
    property RECEIVE_TIMEOUT: dword read getRECEIVE_TIMEOUT write setRECEIVE_TIMEOUT;
    // Retrieves an unsigned long integer value that contains the special status flags that indicate
    // the status of the download currently in progress. This is used by InternetQueryOption.
    property REQUEST_FLAGS:dword read getREQUEST_FLAGS;
      // Not currently implemented by MS-INET API.
      property is_req_ASYNC: boolean read get_is_req_ASYNC;
      // Internet request cannot be cached (an HTTPS request, for example).
      property is_req_CACHE_WRITE_DISABLED: boolean read get_is_req_CACHE_WRITE_DISABLED;
      // Response came from the cache.
      property is_req_FROM_CACHE: boolean read get_is_req_FROM_CACHE;
      // Internet request timed out.
      property is_req_NET_TIMEOUT:boolean read get_is_req_NET_TIMEOUT;
      // Original response contained no headers.
      property is_req_NO_HEADERS: boolean read get_is_req_NO_HEADERS;
      // Not currently implemented by MS-INET API.
      property is_req_PASSIVE: boolean read get_is_req_PASSIVE;
      // Request was made through a proxy.
      property is_req_VIA_PROXY:boolean read get_is_req_VIA_PROXY;

    // Sets or retrieves an unsigned long integer value that contains the priority of requests competing for a connection on an HTTP handle.
    // This is used by InternetQueryOption and InternetSetOption.
    property REQUEST_PRIORITY: dword read getREQUEST_PRIORITY write setREQUEST_PRIORITY;

   // Sets or retrieves a string value that contains the secondary cache key. This is used by InternetQueryOption and InternetSetOption.
    property SECONDARY_CACHE_KEY: string read getSECONDARY_CACHE_KEY write setSECONDARY_CACHE_KEY;

    // Retrieves the certificate for an SSL/PCT (Secure Sockets Layer/Private Communications Technology) server into a formatted string.
    // This is used by InternetQueryOption.
    property SECURITY_CERTIFICATE:string read getSECURITY_CERTIFICATE;
    // Retrieves an unsigned long integer value that contains the security flags for a handle. This option is used by InternetQueryOption.
    property SECURITY_FLAGS: dword read getSECURITY_FLAGS;

      property sec_is_128BIT: boolean read get_sec_is_128BIT;        // Identical to the preferred value STRENGTH_STRONG.
      property sec_is_40BIT: boolean read get_sec_is_40BIT;          // Identical to the preferred value STRENGTH_WEAK.
      property sec_is_56BIT: boolean read get_sec_is_56BIT;          // Identical to the preferred value STRENGTH_MEDIUM.
      property sec_is_FORTEZZ_A: boolean read get_sec_is_FORTEZZ_A;  // Indicates Fortezza has been used to provide secrecy, authentication, and/or integrity for the specified connection.
      property sec_is_IETFSSL4: boolean read get_sec_is_IETFSSL4;    // Not currently implemented.
      property sec_is_IGNORE_CERT_CN_INVALID: boolean read get_sec_is_IGNORE_CERT_CN_INVALID;      // Ignores the ERROR_INTERNET_SEC_CERT_CN_INVALID error message.
      property sec_is_IGNORE_CERT_DATE_INVALID: boolean read get_sec_is_IGNORE_CERT_DATE_INVALID;  // Ignores the ERROR_INTERNET_SEC_CERT_DATE_INVALID error message.
      property sec_is_IGNORE_REDIRECT_TO_HTTP: boolean read get_sec_is_IGNORE_REDIRECT_TO_HTTP;    // Ignores the ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR error message.
      property sec_is_IGNORE_REDIRECT_TO_HTTPS: boolean read get_sec_is_IGNORE_REDIRECT_TO_HTTPS;  // Ignores the ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR error message.
      property sec_is_IGNORE_REVOCATION: boolean read get_sec_is_IGNORE_REVOCATION;                // Ignores certificate revocation problems.
      property sec_is_IGNORE_UNKNOWN_CA: boolean read get_sec_is_IGNORE_UNKNOWN_CA;                // Ignores unknown certificate authority problems.
      property sec_is_IGNORE_WRONG_USAGE: boolean read get_sec_is_IGNORE_WRONG_USAGE;              // Ignores incorrect usage problems.
      property sec_is_NORMALBITNESS: boolean read get_sec_is_NORMALBITNESS;                        // Identical to the value property security_STRENGTH_WEAK.
      property sec_is_PCT: boolean read get_sec_is_PCT;              // Not currently implemented.
      property sec_is_PCT4: boolean read get_sec_is_PCT4;            // Not currently implemented.
      property sec_is_SECURE: boolean read get_sec_is_SECURE;        // Uses secure transfers.
      property sec_is_SSL: boolean read get_sec_is_SSL;              // Not currently implemented.
      property sec_is_SSL3: boolean read get_sec_is_SSL3;            // Not currently implemented.
      property sec_is_STRENGTH_MEDIUM: boolean read get_sec_is_STRENGTH_MEDIUM;                    // Uses medium (56-bit) encryption.
      property sec_is_STRENGTH_STRONG: boolean read get_sec_is_STRENGTH_STRONG;                    // Uses strong (128-bit) encryption.
      property sec_is_STRENGTH_WEAK: boolean read get_sec_is_STRENGTH_WEAK;                        // Uses weak (40-bit) encryption.
      property sec_is_UNKNOWNBIT: boolean read get_sec_is_UNKNOWNBIT;                              // The bit size used in the encryption is unknown.

    // Retrieves an unsigned long integer value that contains the bit size of the encryption key. The larger the number,
    // the greater the encryption strength being used. This is used by InternetQueryOption.
    property SECURITY_KEY_BITNESS: dword read getSECURITY_KEY_BITNESS;

    // Sets or retrieves an unsigned long integer value that contains the time-out value to send a request.
    // Units are in milliseconds. If the send takes longer than this time-out value, the send is canceled.
    // This option can be used on any HINTERNET handle, including a NULL handle. It is used by InternetQueryOption and InternetSetOption.
    property SEND_TIMEOUT: dword read getSEND_TIMEOUT write setSEND_TIMEOUT;

    // Retrieves a string value that contains the full URL of a downloaded resource.
    // If the original URL contained any extra information (such as search strings or anchors), or if the call was redirected,
    // the URL returned will differ from the original. This option is valid on HINTERNET handles returned by
    // InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest. It is used by InternetQueryOption.
    property URL: string read getURL;

    // Sets or retrieves the user agent string on handles supplied by InternetOpen and used in subsequent HttpSendRequest functions,
    // as long as it is not overridden by a header added by HttpAddRequestHeaders or HttpSendRequest.
    // This is used by InternetQueryOption and InternetSetOption.
    property USER_AGENT: string read getUSER_AGENT write setUSER_AGENT;

    // Sets or retrieves a string that contains the user name associated with a handle returned by InternetConnect.
    // This is used by InternetQueryOption and InternetSetOption.
    property USERNAME: string read getUSERNAME write setUSERNAME;

    // Retrieves an INTERNET_VERSION_INFO structure that contains the version number of Wininet.dll.
    // This option can be used on a NULLHINTERNET handle by InternetQueryOption.
    property VERSION:INTERNET_VERSION_INFO read getVERSION;

    // Sets or retrieves an unsigned long integer value that contains the size of the write buffer.
    // This option can be used on HINTERNET handles returned by FtpOpenFile and InternetConnect (FTP session only).
    // It is used by InternetQueryOption and InternetSetOption.
    property WRITE_BUFFER_SIZE: dword read getWRITE_BUFFER_SIZE write setWRITE_BUFFER_SIZE;
  end;


  TINETApi_Intf = class (TObject)
  private
    fCallbackEvent:TInternet_Status_Callback_proc;
  protected
    {-----------------------------------------------------------------------------------------------------------------------}
    {---------------------------------------- COMMON API FUNCTION BROKERS --------------------------------------------------}
    {-----------------------------------------------------------------------------------------------------------------------}

    {  **** Formats a date and time according to the HTTP version 1.0 specification                                         }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internettimefromsystemtime.asp         }
    function InternalInternetTimeFromSystemTime(
                              const pst: TSystemTime;              // A SYSTEMTIME structure that contains the date and time to format.
                              dwRFC: DWORD;                        // Value that contains the RFC format used.
                                                                   //   Currently, the only valid format is INTERNET_RFC1123_FORMAT.
                              var TimeStr: string                  // [out] A string buffer that receives the formatted date and time.
                                                                   //    The buffer should be of size INTERNET_RFC1123_BUFSIZE.
                              ): boolean; virtual;                 // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                                   //    To get extended error information, call GetLastError

    {  **** Converts an HTTP time/date string to a SYSTEMTIME structure.                                                    }
    { See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internettimetosystemtime.asp            }
    function InternalInternetTimeToSystemTime(
                              const Time: string;                   // date/time string to convert
                              var pst: TSystemTime;                 // [out] a SYSTEMTIME structure that receives the converted time.
                              dwReserved: DWORD                     // Reserved. Must be set to 0.
                              ): boolean; virtual;                  // Returns TRUE if the string was converted, or FALSE otherwise.
                                                                    //   To get extended error information, call GetLastError.
    {  **** Creates a URL from its component parts.                                                                         }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcreateurl.asp for more details }
    function InternalInternetCreateUrl(
                              UrlComponents: TURL_Components;     // A TURLComponents structure that contains the components from which to create the URL.
                              options:TInternetURLCrackOptions;  // that contains the flags that control the operation of this function. This can be one or both of these values:
                                                                 //    ICU_ESCAPE   : Converts all escape sequences (%xx) to their corresponding characters.
                                                                 //    ICU_USERNAME : When adding the user name, uses the name that was specified at logon time.
                              var Url: string                    // A string variable  that receives the URL.
                              ): boolean;                        // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                                 //    To get extended error information, call GetLastError.

    {  **** Canonicalizes a URL, which includes converting unsafe characters and spaces into escape sequences.              }
    {  see http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcanonicalizeurl.asp            }
    function InternalInternetCanonicalizeUrl(
                              const Url: string;                 // The string that contains the URL to canonicalize.
                              var Buffer: string;                // the buffer that receives the resulting canonicalized URL.
                              dwFlags: DWORD                     // that contains the flags that control canonicalization.
                                                                 //    If no flags are specified (dwFlags = 0), the function converts all unsafe characters and
                                                                 //    meta sequences (such as \.,\ .., and \...) to escape sequences.
                                                                 //    dwFlags can be one of the following values:
                                                                 //    ICU_BROWSER_MODE       : Does not encode or decode characters after "#" or "?", and does not remove trailing white space after "?". If this value is not specified, the entire URL is encoded and trailing white space is removed.
                                                                 //    ICU_DECODE             : Converts all %XX sequences to characters, including escape sequences, before the URL is parsed.
                                                                 //    ICU_ENCODE_PERCENT     : Encodes any percent signs encountered. By default, percent signs are not encoded. This value is available in Microsoft® Internet Explorer 5 and later versions of the Microsoft Win32® Internet functions.
                                                                 //    ICU_ENCODE_SPACES_ONLY : Encodes spaces only.
                                                                 //    ICU_NO_ENCODE          : Does not convert unsafe characters to escape sequences.
                                                                 //    ICU_NO_META            : Does not remove meta sequences (such as "." and "..") from the URL.
                              ): boolean; virtual;               // Returns TRUE if successful, or FALSE otherwise.
                                                                 //    To get extended error information, call GetLastError.
                                                                 //    Possible errors include:
                                                                 //    ERROR_BAD_PATHNAME         : The URL could not be canonicalized. This flag is valid for Internet Explorer 5 and later versions of the Win32 Internet API.
                                                                 //    ERROR_INSUFFICIENT_BUFFER  : The canonicalized URL is too large to fit in the buffer provided. The lpdwBufferLength parameter is set to the size, in bytes, of the buffer required to hold the canonicalized URL.
                                                                 //    ERROR_INTERNET_INVALID_URL : The format of the URL is invalid.
                                                                 //    ERROR_INVALID_PARAMETER    : There is an invalid string, buffer, buffer size, or flags parameter.

    {  **** Combines a base and relative URL into a single URL. The resultant URL will be canonicalized.                    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcombineurl.asp                 }
    function InternalInternetCombineUrl(
                              const BaseUrl: string;             // A string variable that contains the base URL.
                              const RelativeUrl: string;         // A string variable that contains the relative URL.
                              var Buffer: string;                // A buffer that receives the combined URL
                              dwFlags: DWORD                     // That contains the flags controlling the operation of the function.
                                                                 //    This can be one of the following values:
                                                                 //    ICU_BROWSER_MODE       : Does not encode or decode characters after "#" or "?", and does not remove trailing white space after "?". If this value is not specified, the entire URL is encoded and trailing white space is removed.
                                                                 //    ICU_DECODE             : Converts all %XX sequences to characters, including escape sequences, before the URL is parsed.
                                                                 //    ICU_ENCODE_PERCENT     : Encodes any percent signs encountered. By default, percent signs are not encoded. This value is available in Microsoft® Internet Explorer 5 and later versions of the Microsoft Win32® Internet functions.
                                                                 //    ICU_ENCODE_SPACES_ONLY : Encodes spaces only.
                                                                 //    ICU_NO_ENCODE          : Does not convert unsafe characters to escape sequences.
                                                                 //    ICU_NO_META            : Does not remove meta sequences (such as "." and "..") from the URL.
                               ): boolean; virtual;              // Returns TRUE if successful, or FALSE otherwise.
                                                                 //    To get extended error information, call GetLastError.
                                                                 //    Possible errors include:
                                                                 //    ERROR_BAD_PATHNAME         : The URL could not be canonicalized. This flag is valid for Internet Explorer 5 and later versions of the Win32 Internet API.
                                                                 //    ERROR_INSUFFICIENT_BUFFER  : The canonicalized URL is too large to fit in the buffer provided. The lpdwBufferLength parameter is set to the size, in bytes, of the buffer required to hold the canonicalized URL.
                                                                 //    ERROR_INTERNET_INVALID_URL : The format of the URL is invalid.
                                                                 //    ERROR_INVALID_PARAMETER    : There is an invalid string, buffer, buffer size, or flags parameter.

    {  **** Initializes an application's use of the Microsoft® Win32® Internet functions.                                   }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetopen.asp for more detail       }
    function  InternalInternetOpen(
                           Agent: String;                         // a string variable that contains the name of the application or entity calling the Internet functions (for example, Microsoft Internet Explorer). This name is used as the user agent in the HTTP protocol
                           dwAccessType: DWORD;                   // Type of access required. This can be one of the following values
                                                                  //   INTERNET_OPEN_TYPE_DIRECT    : Resolves all host names locally
                                                                  //   INTERNET_OPEN_TYPE_PRECONFIG : Retrieves the proxy or direct configuration from the registry.
                                                                  //   INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY : Retrieves the proxy or direct configuration from the registry and prevents the use of a startup Microsoft JScript® or Internet Setup (INS) file
                                                                  //   INTERNET_OPEN_TYPE_PROXY     : Passes requests to the proxy unless a proxy bypass list is supplied and the name to be resolved bypasses the proxy. In this case, the function uses INTERNET_OPEN_TYPE_DIRECT.
                           Proxy: string;                         // A string variable that contains the name of the proxy server(s) to use when proxy access is specified by setting dwAccessType to INTERNET_OPEN_TYPE_PROXY.
                                                                  //   Do not use an empty string, because InternetOpen will use it as the proxy name. The Win32 Internet functions recognize only CERN type proxies (HTTP only) and the TIS FTP gateway (FTP only).
                                                                  //   If Internet Explorer is installed, the Win32 Internet functions also support SOCKS proxies.
                                                                  //   FTP and Gopher requests can be made through a CERN type proxy either by changing them to an HTTP request or by using InternetOpenUrl.
                                                                  //   If dwAccessType is not set to INTERNET_OPEN_TYPE_PROXY, this parameter is ignored and should be set to NULL.
                           ProxyBypass: string;                   // a string variable that contains an optional list of host names or IP addresses, or both, that should not be routed through the proxy when dwAccessType is set to INTERNET_OPEN_TYPE_PROXY.
                                                                  //   The list can contain wildcards. Do not use an empty string, because InternetOpen will use it as the proxy bypass list.
                                                                  //   If this parameter specifies the "<local>" macro as the only entry, the function bypasses any host name that does not contain a period.
                                                                  //   If dwAccessType is not set to INTERNET_OPEN_TYPE_PROXY, this parameter is ignored and should be set to NULL
                           dwFlags: DWORD                         // that contains the flags that indicate various options affecting the behavior of the function.
                                                                  //   This can be a combination of these values:
                                                                  //   INTERNET_FLAG_ASYNC      : Makes only asynchronous requests on handles descended from the handle returned from this function.
                                                                  //   INTERNET_FLAG_FROM_CACHE : Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned.
                                                                  //   INTERNET_FLAG_OFFLINE    : Identical to INTERNET_FLAG_FROM_CACHE. Does not make network requests.
                           ): HINTERNET; virtual;                 // Returns a valid handle that the application passes to subsequent Win32 Internet functions. If InternetOpen fails, it returns NULL.
                                                                  //   To retrieve a specific error message, call GetLastError.

    {  **** Opens an File Transfer Protocol (FTP), Gopher, or HTTP session for a given site.                                }
    {  See  http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetconnect.asp  for more details }
    function  InternalInternetConnect(
                           hInet: HINTERNET;                      // Valid HINTERNET handle returned by a previous call to InternalInternetOpen.
                           ServerName: string;                    // string that contains the host name of an Internet server. Alternately, the string can contain the IP number of the site, in ASCII dotted-decimal format (for example, 11.0.1.45).
                           nServerPort: INTERNET_PORT;            // that specifies the Transmission Control Protocol/Internet Protocol (TCP/IP) port on the server. These flags set only the port that is used. The service is set by the value of dwService.
                                                                  //    This can be one of the following values:
                                                                  //    INTERNET_DEFAULT_FTP_PORT    : Uses the default port for FTP servers (port 21).
                                                                  //    INTERNET_DEFAULT_GOPHER_PORT : Uses the default port for Gopher servers (port 70).
                                                                  //    INTERNET_DEFAULT_HTTP_PORT   : Uses the default port for HTTP servers (port 80).
                                                                  //    INTERNET_DEFAULT_HTTPS_PORT  : Uses the default port for Secure Hypertext Transfer Protocol (HTTPS) servers (port 443).
                                                                  //    INTERNET_DEFAULT_SOCKS_PORT  : Uses the default port for SOCKS firewall servers (port 1080).
                                                                  //    INTERNET_INVALID_PORT_NUMBER : Uses the default port for the service specified by dwService.
                           Username: string;                      // string that contains the name of the user to log on. If this parameter is NULL, the function uses an appropriate default, except for HTTP;
                                                                  //    a NULL parameter in HTTP causes the server to return an error. For the FTP protocol, the default is "anonymous".
                           Password: string;                      // string that contains the password to use to log on. If both Password and Username are NULL, the function uses the default "anonymous" password.
                                                                  //    In the case of FTP, the default password is the user's e-mail name.
                                                                  //    If Password is NULL, but Username is not NULL, the function uses a blank password.
                           dwService: DWORD;                      // that contains the type of service to access. This can be one of the following values:
                                                                  //    INTERNET_SERVICE_FTP    : FTP service.
                                                                  //    INTERNET_SERVICE_GOPHER : Gopher service.
                                                                  //    INTERNET_SERVICE_HTTP   : HTTP service.
                           dwFlags: DWORD;                        // that contains the flags specific to the service used.
                                                                  //    When the value of dwService is INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE causes the application to use passive FTP semantics.
                           dwContext: DWORD                       // an unsigned long integer value that contains an application-defined value that is used to identify the application context for the returned handle in callbacks.
                           ): HINTERNET;virtual;                  // Returns a valid handle to the FTP, Gopher, or HTTP session if the connection is successful, or NULL otherwise.
                                                                  //    To retrieve extended error information, call GetLastError.

    {  **** Closes a single Internet handle.                                                                                }
    {  See http://msdn.microsoft.com/networking/wininet/reference/functions/internetclosehandle.asp                         }
    function InternalInternetCloseHandle(
                           hInet: HINTERNET                       // Valid HINTERNET handle to be closed
                           ): Boolean; virtual;                   // Returns TRUE if the handle is successfully closed, or FALSE otherwise.
                                                                  //    To get extended error information, call GetLastError.

    {  **** Opens a resource specified by a complete FTP, Gopher, or HTTP URL.                                              }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetopenurl.asp                    }
    function InternalInternetOpenUrl(
                           hInet: HINTERNET;                      // HINTERNET handle to the current Internet session. The handle must have been returned by a previous call to InternalInternetOpen.
                           const Url: string;                     // A string variable that contains the URL to begin reading. Only URLs beginning with ftp:, gopher:, http:, or https: are supported.
                           const Headers: string;                 // A string variable that contains the headers to be sent to the HTTP server.
                                                                  //    (For more information, see the description of the Headers parameter in the InternalHttpSendRequest function.)
                           dwFlags: DWORD;                        // value that contains the API flags. This can be one of the following values:
                                                                  //    INTERNET_FLAG_EXISTING_CONNECT        :Attempts to use an existing InternetConnect object if one exists with the same attributes required to make the request. This is useful only with FTP operations, since FTP is the only protocol that typically performs multiple operations during the same session. The Microsoft® Win32® Internet API caches a single connection handle for each HINTERNET handle generated by InternetOpen.
                                                                  //    INTERNET_FLAG_HYPERLINK               :Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
                                                                  //    INTERNET_FLAG_IGNORE_CERT_CN_INVALID  :Disables Win32 Internet function checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. Win32 Internet functions use a simple check against certificates by comparing for matching host names and simple wildcarding rules.
                                                                  //    INTERNET_FLAG_IGNORE_CERT_DATE_INVALID:Disables Win32 Internet function checking of SSL/PCT-based certificates for proper validity dates.
                                                                  //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP :Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTPS to HTTP URLs.
                                                                  //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS:Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTP to HTTPS URLs.
                                                                  //    INTERNET_FLAG_KEEP_CONNECTION         :Uses keep-alive semantics, if available, for the connection. This flag is required for Microsoft Network (MSN), NT LAN Manager (NTLM), and other types of authentication.
                                                                  //    INTERNET_FLAG_NEED_FILE               :Causes a temporary file to be created if the file cannot be cached.
                                                                  //    INTERNET_FLAG_NO_AUTH                 :Does not attempt authentication automatically.
                                                                  //    INTERNET_FLAG_NO_AUTO_REDIRECT        :Does not automatically handle redirection in HttpSendRequest.
                                                                  //    INTERNET_FLAG_NO_CACHE_WRITE          :Does not add the returned entity to the cache.
                                                                  //    INTERNET_FLAG_NO_COOKIES              :Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database.
                                                                  //    INTERNET_FLAG_NO_UI                   :Disables the cookie dialog box.
                                                                  //    INTERNET_FLAG_PASSIVE                 :Uses passive FTP semantics. InternetOpenUrl uses this flag for FTP files and directories.
                                                                  //    INTERNET_FLAG_PRAGMA_NOCACHE          :Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
                                                                  //    INTERNET_FLAG_RAW_DATA                :Returns the data as a GOPHER_FIND_DATA structure when retrieving Gopher directory information, or as a WIN32_FIND_DATA structure when retrieving FTP directory information. If this flag is not specified or if the call was made through a CERN proxy, InternetOpenUrl returns the HTML version of the directory.
                                                                  //    INTERNET_FLAG_RELOAD                  :Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
                                                                  //    INTERNET_FLAG_RESYNCHRONIZE           :Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded.
                                                                  //    INTERNET_FLAG_SECURE                  :Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests.
                           dwContext: DWORD                       // Value that contains the application-defined value that is passed, along with the returned handle, to any callback functions.
                           ): HINTERNET; virtual;                 // Returns a valid handle to the FTP, Gopher, or HTTP URL if the connection is successfully established, or NULL if the connection fails. To retrieve a specific error message, call GetLastError.
                                                                  //    To determine why access to the service was denied, call InternetGetLastResponseInfo.

    {  **** Reads data from a handle opened by the InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest function.}
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetreadfile.asp                    }
    function InternalInternetReadFile(
                           hFile: HINTERNET;                      // Valid HINTERNET handle returned from a previous call to InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest.
                           lpBuffer: Pointer;                     // Pointer to a buffer that receives the data to read.
                           dwNumberOfBytesToRead: DWORD;          // Value that contains the number of bytes to read.
                           var lpdwNumberOfBytesRead: DWORD       // A dword variable that receives the number of bytes read. InternetReadFile sets this value to zero before doing any work or error checking.
                           ): boolean; virtual;                   // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
                                                                  //    An application can also use InternetGetLastResponseInfo when necessary.

    {  **** Sets a file position for InternetReadFile. This is a synchronous call; however, subsequent calls to
       **** InternetReadFile might block or return pending if the data is not available from the cache and the
       server does not support random access.                                                                               }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetfilepointer.asp             }

    {  ***************************** IMPORTANT REMARKS OF USING THIS FUNCTION ********************************************

       !!!! This function cannot be used once the end of the file has been reached by InternetReadFile. !!!!

       For HINTERNET handles created by HttpOpenRequest and sent by HttpSendRequestEx, a call to HttpEndRequest must be
       made on the handle before InternetSetFilePointer is used.

       InternetSetFilePointer cannot be used reliably if the content length is unknown.                                     }
    function InternalInternetSetFilePointer(
                           hFile: HINTERNET;                      // Valid HINTERNET handle returned from a previous call to InternetOpenUrl (on an HTTP or Secure Hypertext Transfer Protocol (HTTPS)URL) or
                                                                  //    HttpOpenRequest (using the GET or HEAD HTTP verb and passed to HttpSendRequest or HttpSendRequestEx). This handle must not have been created with
                                                                  //    the INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_NO_CACHE_WRITE value set.
                           lDistanceToMove: Longint;              // that specifies the number of bytes to move the file pointer. A positive value moves the pointer forward in the file; a negative value moves it backward.
                           pReserved: Pointer;                    // Reserved. Must be set to NULL.
                           dwMoveMethod: DWORD;                   // value that indicates the starting point for the file pointer move. This can be one of the following values.
                                                                  //    FILE_BEGIN   : Starting point is zero or the beginning of the file. If FILE_BEGIN is specified, lDistanceToMove is interpreted as an unsigned location for the new file pointer.
                                                                  //    FILE_CURRENT : Current value of the file pointer is the starting point.
                                                                  //    FILE_END     : Current end-of-file position is the starting point. This method fails if the content length is unknown.
                           dwContext: DWORD                       // Reserved. Must be set to 0.
                           ): DWORD; virtual;                     // Returns the current file position if the function succeeds, or -1 otherwise.

    { **** Writes data to an open Internet file.                                                                            }
    { See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetwritefile.asp                   }
    function InternalInternetWriteFile(
                          hFile: HINTERNET;                       // Valid HINTERNET handle returned from a previous call to FtpOpenFile or an HINTERNET handle sent by HttpSendRequestEx
                          lpBuffer: Pointer;                      // Pointer to a buffer that contains the data to be written to the file.
                          dwNumberOfBytesToWrite: DWORD;          // Unsigned long integer value that contains the number of bytes to write to the file.
                          var lpdwNumberOfBytesWritten: DWORD     // an unsigned long integer variable that receives the number of bytes written to the buffer.
                                                                  //    InternetWriteFile sets this value to zero before doing any work or error checking.
                          ): boolean; virtual;                    // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                                  //    To get extended error information, call GetLastError.
                                                                  //    An application can also use InternetGetLastResponseInfo when necessary.


    {  **** Queries the server to determine the amount of data available.
           -------- IMPORTANT Remarks of Function -----------
           This function returns the number of bytes of data that are available to be read immediately by a subsequent
           call to InternetReadFile. If there is currently no data available and the end of the file has not been reached,
           the request waits until data becomes available. The amount of data remaining will not be recalculated until
           all available data indicated by the call to InternetQueryDataAvailable is read.

           For HINTERNET handles created by HttpOpenRequest and sent by HttpSendRequestEx,
           a call to HttpEndRequest must be made on the handle before InternetQueryDataAvailable can be used.               }

    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetquerydataavailable.asp         }
    function InternalInternetQueryDataAvailable(
                          hFile: HINTERNET;                       // Valid HINTERNET handle, as returned by InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest.
                          var lpdwNumberOfBytesAvailable: DWORD;  // variable that receives the number of available bytes.
                          dwFlags: DWORD;                         // Reserved. Must be set to 0.
                          dwContext: DWORD                        // Reserved. Must be set to 0.
                          ): boolean; virtual;                    // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                                  //    To get extended error information, call GetLastError.
                                                                  //    If the function finds no matching files,
                                                                  //    GetLastError returns ERROR_NO_MORE_FILES.

    {  **** Continues a file search started as a result of a previous call to FtpFindFirstFile or GopherFindFirstFile.      }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetfindnextfile.asp               }
    function InternalInternetFindNextFile(
                          hFind: HINTERNET;                       // Valid HINTERNET handle returned from either FtpFindFirstFile or GopherFindFirstFile,
                                                                  //    or from InternetOpenUrl (directories only).
                          lpvFindData: Pointer                    // [out] Pointer to the buffer that receives information about the found file or directory.
                                                                  //     The format of the information placed in the buffer depends on the protocol in use.
                                                                  //     The FTP protocol returns a WIN32_FIND_DATA structure, and the Gopher protocol returns a GOPHER_FIND_DATA structure.
                          ): boolean; virtual;                    // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                                  //     To get extended error information, call GetLastError.
                                                                  //     If the function finds no matching files, GetLastError returns ERROR_NO_MORE_FILES.

    {  **** Queries an Internet option on the specified handle.
           -------- IMPORTANT Remarks of Function -----------
          GetLastError will return the ERROR_INVALID_PARAMETER if an option flag that is invalid for the specified handle type is passed to the dwOption parameter.
          For more detailed information on how to query Microsoft® Win32® Internet (WinInet) options
          see "Setting and Retrieving Internet Options" <http://msdn.microsoft.com/workshop/networking/wininet/tutorials/options.asp>.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetqueryoption.asp                }
    function InternalInternetQueryOption(
                          hInet: HINTERNET;                       // HINTERNET handle on which to query information.
                          dwOption: DWORD;                        // value that contains the Internet option to query.
                                                                  //    This can be one of the "Option Flags" <http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/wininet/reference/constants/flags.asp> values
                          lpBuffer: Pointer;                      // [out] Pointer to a buffer that receives the option setting.
                                                                  //    Strings returned by InternetQueryOption are globally allocated,
                                                                  //    so the calling application must globally free the string when it is finished using it.
                          var lpdwBufferLength: DWORD             // [in, out] Pointer to an unsigned long integer variable that contains the length of lpBuffer.
                                                                  //    If lpBuffer contains a string, lpdwBufferLength points to the length of lpBuffer in bytes.
                                                                  //    If lpBuffer contains anything other than a string, lpdwBufferLength points to the length of lpBuffer in BYTEs.
                                                                  //    When InternetQueryOption returns, lpdwBufferLength points to the length of the data placed into lpBuffer.
                                                                  //    If GetLastError returns ERROR_INSUFFICIENT_BUFFER, this parameter points to the number of bytes required to hold the requested information.
                          ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.

    {  **** Sets an Internet option.
           -------- IMPORTANT Remarks of Function -----------
          GetLastError will return the ERROR_INVALID_PARAMETER if an option flag that is invalid for the specified handle type is passed to the dwOption parameter.
          For more detailed information on how to query Microsoft® Win32® Internet (WinInet) options
          see "Setting and Retrieving Internet Options" <http://msdn.microsoft.com/workshop/networking/wininet/tutorials/options.asp>.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetoption.asp                   }
    function InternalInternetSetOption(
                          hInet: HINTERNET;                       //  HINTERNET handle on which to set information.
                          dwOption: DWORD;                        // value that contains the Internet option to query.
                                                                  //    This can be one of the "Option Flags" <http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/wininet/reference/constants/flags.asp> values
                          lpBuffer: Pointer;                      // [in] Pointer to a buffer that contains the option setting.
                          dwBufferLength: DWORD                   // [in] Unsigned long integer value that contains the length of the lpBuffer buffer.
                                                                  //    If lpBuffer contains a string, dwBufferLength is the length of lpBuffer in TCHARs.
                                                                  //    If lpBuffer contains anything other than a string, dwBufferLength is the length of lpBuffer in BYTEs.
                                                                  //    When lpBuffer represents a BOOL or a DWORD, dwBufferLength should be set to 4 BYTEs.
                          ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.

    {  **** Allows the user to place a lock on the file that is being used.
           -------- IMPORTANT Remarks of Function -----------
           If the HINTERNET handle passed to hInternet was created using INTERNET_FLAG_NO_CACHE_WRITE or
           INTERNET_FLAG_DONT_CACHE, the function creates a temporary file with the extension .tmp,
           unless it is an HTTPS resource. If the handle was created using INTERNET_FLAG_NO_CACHE_WRITE or
           INTERNET_FLAG_DONT_CACHE and it is accessing an HTTPS resource, InternetLockRequestFile fails.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetlockrequestfile.asp             }
    function InternalInternetLockRequestFile(
                          hInternet: HINTERNET;                   // HINTERNET handle returned by FtpOpenFile, GopherOpenFile, HttpOpenRequest, or InternetOpenUrl.
                          var lphLockRequestInfo: THandle         // [out] Pointer to a handle to store the lock request handle
                          ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.

    {  **** Unlocks a file that was locked using InternetLockRequestFile.                                                   }
    {  See http://msdn.microsoft.com/library/networking/wininet/reference/functions/internetunlockrequestfile.asp           }
    function InternalInternetUnlockRequestFile(
                          hLockRequestInfo: THANDLE               // Lock request handle that was returned by InternetLockRequestFile.
                          ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.

    {  **** Sets up a callback function that Microsoft® Win32® Internet functions can call as progress is made during an operation.
           -------- IMPORTANT Remarks of Function -----------
           Both synchronous and asynchronous functions use the callback function to indicate the progress of the request,
           such as resolving a name, connecting to a server, and so on. The callback function is required for an asynchronous operation.
           The asynchronous request will call back to the application with INTERNET_STATUS_REQUEST_COMPLETE to indicate the request has been completed.
           A callback function can be set on any handle, and is inherited by derived handles. A callback function can be changed using
           InternetSetStatusCallback, providing there are no pending requests that need to use the previous callback value.
           Note, however, that changing the callback function on a handle does not change the callbacks on derived handles,
           such as that returned by InternetConnect. You must change the callback function at each level.
           Many of the Win32 Internet functions perform several operations on the network.
           Each operation can take time to complete, and each can fail.
           It is sometimes desirable to display status information during a long-term operation.
           You can display status information by setting up an Internet status callback function that cannot be removed as long as
           any callbacks or any asynchronous functions are pending.
           After initiating InternetSetStatusCallback, the callback function can be accessed from within any Win32 Internet function
           for monitoring time-intensive network operations.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetstatuscallback.asp          }
    function InternalInternetSetStatusCallback(
                  hInet: HINTERNET;                               // HINTERNET handle for which the callback is to be set.
                  lpfnInternetCallback: PFNInternetStatusCallback // Pointer to the callback function to call when progress is made,
                                                                  //     or to return NULL to remove the existing callback function.
                                                                  //  For more information about the callback function,
                                                                  //  see "INTERNET_STATUS_CALLBACK" <http://msdn.microsoft.com/workshop/networking/wininet/reference/prototypes/internet_status_callback.asp>.
                  ): PFNInternetStatusCallback; virtual;          //  Returns the previously defined status callback function if successful,
                                                                  //     NULL if there was no previously defined status callback function,
                                                                  //     or INTERNET_INVALID_STATUS_CALLBACK if the callback function is not valid.

    {  Prototype for an application-defined status callback function.
           -------- IMPORTANT Remarks of Function -----------
           Because callbacks are made during processing of the request,
           the application should spend as little time as possible in the callback function to avoid degrading data throughput on the network.
           For example, displaying a dialog box in a callback function can be such a lengthy operation that the server terminates the request.
           The callback function can be called in a thread context different from the thread that initiated the request.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/prototypes/internet_status_callback.asp }
    procedure doOnCallback(
          hInet:HINTERNET;                     // Handle for which the callback function is being called.
          dwContext:DWORD;                      // Pointer to an unsigned long integer value that contains
                                                //   the application-defined context value associated with hInternet.
          dwInternetStatus:DWORD;               // Unsigned long integer value that contains the status code that indicates
                                                //    why the callback function is being called. This can be one of the following values:
                                                //    INTERNET_STATUS_CLOSING_CONNECTION   : Closing the connection to the server. The lpvStatusInformation parameter is NULL.
                                                //    INTERNET_STATUS_CONNECTED_TO_SERVER  : Successfully connected to the socket address (SOCKADDR) pointed to by lpvStatusInformation
                                                //    INTERNET_STATUS_CONNECTING_TO_SERVER : Connecting to the socket address (SOCKADDR) pointed to by lpvStatusInformation.
                                                //    INTERNET_STATUS_CONNECTION_CLOSED    : Successfully closed the connection to the server. The lpvStatusInformation parameter is NULL.
                                                //    INTERNET_STATUS_CTL_RESPONSE_RECEIVED: Not implemented.
                                                //    INTERNET_STATUS_DETECTING_PROXY      : Notifies the client application that a proxy has been detected.
                                                //    INTERNET_STATUS_HANDLE_CLOSING       : This handle value has been terminated.
                                                //    INTERNET_STATUS_HANDLE_CREATED       : Used by InternetConnect to indicate it has created the new handle. This lets the application call InternetCloseHandle from another thread, if the connect is taking too long. The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
                                                //    INTERNET_STATUS_INTERMEDIATE_RESPONSE: Received an intermediate (100 level) status code message from the server.
                                                //    INTERNET_STATUS_NAME_RESOLVED        : Successfully found the IP address of the name contained in lpvStatusInformation
                                                //    INTERNET_STATUS_PREFETCH             : Not implemented.
                                                //    INTERNET_STATUS_RECEIVING_RESPONSE   : Waiting for the server to respond to a request. The lpvStatusInformation parameter is NULL.
                                                //    INTERNET_STATUS_REDIRECT             : An HTTP request is about to automatically redirect the request. The lpvStatusInformation parameter points to the new URL. At this point, the application can read any data returned by the server with the redirect response and can query the response headers. It can also cancel the operation by closing the handle. This callback is not made if the original request specified INTERNET_FLAG_NO_AUTO_REDIRECT.
                                                //    INTERNET_STATUS_REQUEST_COMPLETE     : An asynchronous operation has been completed. The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
                                                //    INTERNET_STATUS_REQUEST_SENT         : Successfully sent the information request to the server. The lpvStatusInformation parameter points to a DWORD containing the number of bytes sent.
                                                //    INTERNET_STATUS_RESOLVING_NAME       : Looking up the IP address of the name contained in lpvStatusInformation
                                                //    INTERNET_STATUS_RESPONSE_RECEIVED    : Successfully received a response from the server. The lpvStatusInformation parameter points to a DWORD containing the number of bytes received.
                                                //    INTERNET_STATUS_SENDING_REQUEST      : Sending the information request to the server. The lpvStatusInformation parameter is NULL.
                                                //    INTERNET_STATUS_STATE_CHANGE         : Moved between a secure (HTTPS) and a nonsecure (HTTP) site.
          lpvStatusInformation:pointer;         // Pointer to a buffer that contains information pertinent to this call to the callback function.
          dwStatusInformationLength:DWORD       // Unsigned long integer value that contains the size, in TCHARs, of the lpvStatusInformation buffer.
          );virtual;                            // Void function so No return value.

    {  **** Retrieves the last Microsoft® Win32® Internet function error description or server response on the thread calling this function.
          -------- IMPORTANT Remarks of Function -----------
          The FTP and Gopher protocols can return additional text information along with most errors.
          This extended error information can be retrieved by using the InternetGetLastResponseInfo function whenever
          GetLastError returns ERROR_INTERNET_EXTENDED_ERROR (occurring after an unsuccessful function call).
          The buffer pointed to by lpszBuffer must be large enough to hold both the error string and a zero terminator at the end of the string.
          However, note that the value returned in lpdwBufferLength does not include the terminating zero.

          InternetGetLastResponseInfo can be called multiple times until another Win32 Internet function is called on this thread.
          When another function is called, the internal buffer that is storing the last response information is cleared.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetgetlastresponseinfo.asp        }
    function InternalInternetGetLastResponseInfo(
               var lpdwError: DWORD;                  // [out] Pointer to an unsigned long integer variable that receives
                                                      //       an error message pertaining to the operation that failed.
               var Buffer: string                     // [out] a buffer that receives the error text.
               ): boolean; virtual;                   // Returns TRUE if error text was successfully written to the buffer, or FALSE otherwise.
                                                      //   To get extended error information, call GetLastError.
                                                      //   If the buffer is too small to hold all the error text,
                                                      //   GetLastError returns ERROR_INSUFFICIENT_BUFFER, and the lpdwBufferLength parameter contains
                                                      //   the minimum buffer size required to return all the error text.


    {-----------------------------------------------------------------------------------------------------------------------}
    {----------------------------------------- HTTP API FUNCTION BROKERS ---------------------------------------------------}
    {-----------------------------------------------------------------------------------------------------------------------}


    {  **** Creates an HTTP request handle.
          -------- IMPORTANT Remarks of Function -----------
          HttpOpenRequest creates a new HTTP request handle and stores the specified parameters in that handle.
          An HTTP request handle holds a request to be sent to an HTTP server and contains all RFC822/MIME/HTTP headers
          to be sent as part of the request. Beginning with Microsoft Internet Explorer 5, if lpszVerb is set to "HEAD",
          the Content-Length header is ignored on responses from HTTP/1.1 servers. After the calling application has
          finished using the HINTERNET handle returned by HttpOpenRequest,
          it must be closed using the InternalInternetCloseHandle function.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpopenrequest.asp                    }
    function InternalHttpOpenRequest(
               hConnect: HINTERNET;                   // HINTERNET handle to an HTTP session returned by InternalInternetConnect.
               Verb: string;                          // A string that contains the HTTP verb (valid values 'GET', 'PUT', 'POST, 'HEAD') to use in the request.
                                                      //    If this parameter is NULL, the function uses GET as the HTTP verb.
               ObjectName: string;                    // A string that contains the name of the target object of the specified HTTP verb.
                                                      //    This is generally a file name, an executable module, or a search specifier.
               Version: string;                       // A string that contains the HTTP version. If this parameter is NULL, the function uses HTTP/1.0 as the version.
               Referrer: string;                      // A string that specifies the URL of the document from which the URL in the request (lpszObjectName) was obtained.
                                                      //    If this parameter is NULL, no "referrer" is specified.
               AcceptTypes: TStrings;                 // Address of a null-terminated array of string pointers indicating media types accepted by the client.
                                                      //    If this parameter is NULL, no types are accepted by the client.
                                                      //    Servers generally interpret a lack of accept types to indicate that the client accepts only
                                                      //    documents of type "text/*" (that is, only text documents—no pictures or other binary files).
                                                      //    For a list of valid media types, see "Media Types" at ftp://ftp.isi.edu/in-notes/iana/assignments/media-types/media-types .
               dwFlags: DWORD;                        // Unsigned long integer value that contains the Internet flag values. This can be any of the following values:
                                                      //    INTERNET_FLAG_CACHE_IF_NET_FAIL : Returns the resource from the cache if the network request for the resource fails due to an ERROR_INTERNET_CONNECTION_RESET (the connection with the server has been reset) or ERROR_INTERNET_CANNOT_CONNECT (the attempt to connect to the server failed).
                                                      //    INTERNET_FLAG_HYPERLINK         : Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
                                                      //    INTERNET_FLAG_IGNORE_CERT_CN_INVALID   : Disables Microsoft® Win32® Internet function checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. Win32 Internet functions use a simple check against certificates by comparing for matching host names and simple wildcarding rules.
                                                      //    INTERNET_FLAG_IGNORE_CERT_DATE_INVALID : Disables Win32 Internet function checking of SSL/PCT-based certificates for proper validity dates.
                                                      //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  : Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTPS to HTTP URLs.
                                                      //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS : Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTP to HTTPS URLs.
                                                      //    INTERNET_FLAG_KEEP_CONNECTION          : Uses keep-alive semantics, if available, for the connection. This flag is required for Microsoft Network (MSN), NT LAN Manager (NTLM), and other types of authentication
                                                      //    INTERNET_FLAG_NEED_FILE                : Causes a temporary file to be created if the file cannot be cached.
                                                      //    INTERNET_FLAG_NO_AUTH                  : Does not attempt authentication automatically.
                                                      //    INTERNET_FLAG_NO_AUTO_REDIRECT         : Does not automatically handle redirection in InternalHttpSendRequest.
                                                      //    INTERNET_FLAG_NO_CACHE_WRITE           : Does not add the returned entity to the cache.
                                                      //    INTERNET_FLAG_NO_COOKIES               : Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database.
                                                      //    INTERNET_FLAG_NO_UI                    : Disables the cookie dialog box.
                                                      //    INTERNET_FLAG_PRAGMA_NOCACHE           : Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
                                                      //    INTERNET_FLAG_RELOAD                   : Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
                                                      //    INTERNET_FLAG_RESYNCHRONIZE            : Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded.
                                                      //    INTERNET_FLAG_SECURE                   : Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests.
               dwContext: DWORD
               ): HINTERNET; virtual;


    {  **** Sends the specified request to the HTTP server.
          -------- IMPORTANT Remarks of Function -----------
          HttpSendRequest sends the specified request to the HTTP server and allows the client to
          specify additional headers to send along with the request.The function also lets the client specify
          optional data to send to the HTTP server immediately following the request headers.
          This feature is generally used for "write" operations such as PUT and POST. After the request is sent,
          the status code and response headers from the HTTP server are read. These headers are maintained internally and
          are available to client applications through the InternalHttpQueryInfo function.
          An application can use the same HTTP request handle in multiple calls to HttpSendRequest,
          but the application must read all data returned from the previous call before calling the function again.
          In offline mode, HttpSendRequest returns ERROR_FILE_NOT_FOUND if the resource is not found in the Internet cache.
          There two versions of HttpSendRequest — HttpSendRequestA (used with ANSI builds) and HttpSendRequestW (used with Unicode builds).
          If dwHeadersLength is -1L and lpszHeaders is not NULL, the following will happen:
             If HttpSendRequestA is called, the function assumes that lpszHeaders is zero-terminated (ASCIIZ), and the length is calculated.
             If HttpSendRequestW is called, the function fails with ERROR_INVALID_PARAMETER.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpsendrequest.asp                    }
    function InternalHttpSendRequest(
               hRequest: HINTERNET;                    // HINTERNET handle returned by HttpOpenRequest
               pHeaders: pchar;                         // a buffer variable that contains the additional headers to be appended to the request.
                                                       //    This parameter can be NULL if there are no additional headers to append
               dwHeadersLength: dword;                 // length of buffer
               lpOptional: Pointer;                    // Pointer to a buffer containing any optional data to send immediately after the request headers.
                                                       //    This parameter is generally used for POST and PUT operations.
                                                       //    The optional data can be the resource or information being posted to the server.
                                                       //    This parameter can be NULL if there is no optional data to send.
               dwOptionalLength: DWORD                 // Unsigned long integer value that contains the length, in bytes, of the optional data.
                                                       //    This parameter can be zero if there is no optional data to send.
               ): boolean; virtual;                     // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.

    {  **** Sends the specified request to the HTTP server.                                                                 }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpsendrequestex.asp                  }
    function InternalHttpSendRequestEx(
               hRequest: HINTERNET;                    // HINTERNET handle returned by HttpOpenRequest.
               lpBuffersIn: PInternetBuffers;          // [in] Optional. Pointer to an INTERNET_BUFFERS (see <http://msdn.microsoft.com/workshop/networking/wininet/reference/structures/internet_buffers.asp>) structure.
               lpBuffersOut: PInternetBuffers;         // [out] Optional. Pointer to an INTERNET_BUFFERS structure
               dwFlags: DWORD;                         // [in] One of the following values:
                                                       //    HSR_ASYNC       : Forces asynchronous operations.
                                                       //    HSR_SYNC        : Forces synchronous operations.
                                                       //    HSR_USE_CONTEXT : Forces HttpSendRequestEx to use the context value, even if it is set to zero.
                                                       //    HSR_INITIATE    : Iterative operation (completed by HttpEndRequest).
                                                       //    HSR_DOWNLOAD    : Download resource to file.
                                                       //    HSR_CHUNKED     : Not implemented.
               dwContext: DWORD                        // [in] Unsigned long integer variable that contains the application-defined context value, if a status callback function has been registered.
               ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.

    {  **** Ends an HTTP request that was initiated by HttpSendRequestEx.
          -------- IMPORTANT Remarks of Function -----------
          If lpBuffersOut is not set to NULL, HttpEndRequest will return ERROR_INVALID_PARAMETER.                           }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpendrequest.asp                     }
    function InternalHttpEndRequest(
               hRequest: HINTERNET;                    // [in] HINTERNET handle returned by HttpOpenRequest and sent by HttpSendRequestEx.
               lpBuffersOut: PInternetBuffers;         // [out] Reserved. Must be set to NULL.
               dwFlags: DWORD;                         // [in] Unsigned long integer value that contains the flags that control this function. Can be one of the following values.
                                                       //    HSR_ASYNC       : Forces asynchronous operations.
                                                       //    HSR_SYNC        : Forces synchronous operations.
                                                       //    HSR_USE_CONTEXT : Forces HttpSendRequestEx to use the context value, even if it is set to zero.
                                                       //    HSR_INITIATE    : Iterative operation (completed by HttpEndRequest).
                                                       //    HSR_DOWNLOAD    : Download resource to file.
                                                       //    HSR_CHUNKED     : Not implemented.
               dwContext: DWORD                        // [in] Unsigned long integer variable that contains the application-defined context value, if a status callback function has been registered.
               ): boolean; virtual;                    // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.

    {  **** Retrieves header information associated with an HTTP request.
          -------- IMPORTANT Remarks of Function -----------
          You can retrieve the following types of data from HttpQueryInfo.
            * Strings (default)
            * SYSTEMTIME (for Data: Expires:, headers)
            * DWORD (for STATUS_CODE, CONTENT_LENGTH, and so on, if HTTP_QUERY_FLAG_NUMBER has been used)
         If your application requires that the data be returned as a data type other than a string,
         you must include the appropriate modifier with the attribute passed to dwInfoLevel.
         HttpQueryInfo is available in Microsoft® Internet Explorer 3.0 for the ANSI character set and
         in Internet Explorer 4.0 or later for ANSI and Unicode characters
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpqueryinfo.asp                      }
    {---------------------------------------- Query Info Flags -------------------------------------------------------------}
    {
      HTTP_QUERY_ACCEPT (24)                   : Retrieves the acceptable media types for the response.
      HTTP_QUERY_ACCEPT_CHARSET (25)           : Retrieves the acceptable character sets for the response.
      HTTP_QUERY_ACCEPT_ENCODING (26)          : Retrieves the acceptable content-coding values for the response.
      HTTP_QUERY_ACCEPT_LANGUAGE (27)          : Retrieves the acceptable natural languages for the response.
      HTTP_QUERY_ACCEPT_RANGES (42)            : Retrieves the types of range requests that are accepted for a resource.
      HTTP_QUERY_AGE (48)                      : Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
      HTTP_QUERY_ALLOW (7)                     : Receives the HTTP verbs supported by the server.
      HTTP_QUERY_AUTHORIZATION (28)            : Retrieves the authorization credentials used for a request.
      HTTP_QUERY_CACHE_CONTROL (49)            : Retrieves the cache control directives.
      HTTP_QUERY_CONNECTION (23)               : Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
      HTTP_QUERY_CONTENT_BASE (50)             : Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
      HTTP_QUERY_CONTENT_DESCRIPTION (4)       : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_CONTENT_DISPOSITION (47)      : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_CONTENT_ENCODING (29)         : Retrieves any additional content codings that have been applied to the entire resource.
      HTTP_QUERY_CONTENT_ID (3)                : Retrieves the content identification.
      HTTP_QUERY_CONTENT_LANGUAGE (6)          : Retrieves the language that the content is in.
      HTTP_QUERY_CONTENT_LENGTH (5)            : Retrieves the size of the resource, in bytes.
      HTTP_QUERY_CONTENT_LOCATION (51)         : Retrieves the resource location for the entity enclosed in the message.
      HTTP_QUERY_CONTENT_MD5 (52)              : Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
      HTTP_QUERY_CONTENT_RANGE (53)            : Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
      HTTP_QUERY_CONTENT_TRANSFER_ENCODING (2) : Receives the additional content coding that has been applied to the resource.
      HTTP_QUERY_CONTENT_TYPE (1)              : Receives the content type of the resource (such as text/html).
      HTTP_QUERY_COOKIE (44)                   : Retrieves any cookies associated with the request.
      HTTP_QUERY_COST (15)                     : No longer supported.
      HTTP_QUERY_CUSTOM (65535)                : Causes HttpQueryInfo to search for the header name specified in lpvBuffer and store the header information in lpvBuffer.
      HTTP_QUERY_DATE (9)                      : Receives the date and time at which the message was originated.
      HTTP_QUERY_DERIVED_FROM (14)             : No longer supported.
      HTTP_QUERY_ECHO_HEADERS (73)             : Not currently implemented.
      HTTP_QUERY_ECHO_HEADERS_CRLF (74)        : Not currently implemented.
      HTTP_QUERY_ECHO_REPLY (72)               : Not currently implemented.
      HTTP_QUERY_ECHO_REQUEST (71)             : Not currently implemented.
      HTTP_QUERY_ETAG (54)                     : Retrieves the entity tag for the associated entity.
      HTTP_QUERY_EXPECT (68)                   : Retrieves the Expect header, which indicates whether the client application should expect 100 series responses.
      HTTP_QUERY_EXPIRES (10)                  : Receives the date and time after which the resource should be considered outdated.
      HTTP_QUERY_FORWARDED (30)                : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_FROM (31)                     : Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
      HTTP_QUERY_HOST (55)                     : Retrieves the Internet host and port number of the resource being requested.
      HTTP_QUERY_IF_MATCH (56)                 : Retrieves the contents of the If-Match request-header field.
      HTTP_QUERY_IF_MODIFIED_SINCE (32)        : Retrieves the contents of the If-Modified-Since header.
      HTTP_QUERY_IF_NONE_MATCH (57)            : Retrieves the contents of the If-None-Match request-header field.
      HTTP_QUERY_IF_RANGE (58)                 : Retrieves the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
      HTTP_QUERY_IF_UNMODIFIED_SINCE (59)      : Retrieves the contents of the If-Unmodified-Since request-header field.
      HTTP_QUERY_LAST_MODIFIED (11)            : Receives the date and time at which the server believes the resource was last modified.
      HTTP_QUERY_LINK (16)                     : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_LOCATION (33)                 : Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
      HTTP_QUERY_MAX (75)                      : Not a query flag. Indicates the maximum value of an HTTP_QUERY_* value.
      HTTP_QUERY_MAX_FORWARDS (60)             : Retrieves the number of proxies or gateways that can forward the request to the next inbound server.
      HTTP_QUERY_MESSAGE_ID (12)               : No longer supported.
      HTTP_QUERY_MIME_VERSION (0)              : Receives the version of the MIME protocol that was used to construct the message.
      HTTP_QUERY_ORIG_URI (34)                 : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_PRAGMA (17)                   : Receives the implementation-specific directives that might apply to any recipient along the request/response chain.
      HTTP_QUERY_PROXY_AUTHENTICATE (41)       : Retrieves the authentication scheme and realm returned by the proxy.
      HTTP_QUERY_PROXY_AUTHORIZATION (61)      : Retrieves the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
      HTTP_QUERY_PROXY_CONNECTION (69)         : Retrieves the Proxy-Connection header.
      HTTP_QUERY_PUBLIC (8)                    : Receives methods available at this server.
      HTTP_QUERY_RANGE (62)                    : Retrieves the byte range of an entity.
      HTTP_QUERY_RAW_HEADERS (21)              : Receives all the headers returned by the server. Each header is terminated by "\0". An additional "\0" terminates the list of headers.
      HTTP_QUERY_RAW_HEADERS_CRLF (22)         : Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
      HTTP_QUERY_REFERER (35)                  : Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
      HTTP_QUERY_REFRESH (46)                  : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_REQUEST_METHOD (45)           : Receives the HTTP verb that is being used in the request, typically GET or POST.
      HTTP_QUERY_RETRY_AFTER (36)              : Retrieves the amount of time the service is expected to be unavailable.
      HTTP_QUERY_SERVER (37)                   : Retrieves information about the software used by the origin server to handle the request.
      HTTP_QUERY_SET_COOKIE (43)               : Receives the value of the cookie set for the request.
      HTTP_QUERY_STATUS_CODE (19)              : Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
      HTTP_QUERY_STATUS_TEXT (20)              : Receives any additional text returned by the server on the response line.
      HTTP_QUERY_TITLE (38)                    : Obsolete. Maintained for legacy application compatibility only.
      HTTP_QUERY_TRANSFER_ENCODING (63)        : Retrieves the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
      HTTP_QUERY_UNLESS_MODIFIED_SINCE (70)    : Retrieves the Unless-Modified-Since header.
      HTTP_QUERY_UPGRADE (64)                  : Retrieves the additional communication protocols that are supported by the server.
      HTTP_QUERY_URI (13)                      : Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.
      HTTP_QUERY_USER_AGENT (39)               : Retrieves information about the user agent that made the request.
      HTTP_QUERY_VARY (65)                     : Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
      HTTP_QUERY_VERSION (18)                  : Receives the last response code returned by the server.
      HTTP_QUERY_VIA (66)                      : Retrieves the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
      HTTP_QUERY_WARNING (67)                  : Retrieves additional information about the status of a response that might not be reflected by the response status code.
      HTTP_QUERY_WWW_AUTHENTICATE (40)         : Retrieves the authentication scheme and realm returned by the server.
}
    function InternalHttpQueryInfo(
               hRequest: HINTERNET;                    // [in] HINTERNET request handle returned by InternalHttpOpenRequest or InternalInternetOpenUrl.
               dwInfoLevel: DWORD;                     // [in] Unsigned long integer value that contains a combination of an attribute to retrieve and the flags that modify the request. For a list of possible attribute and modifier values,
                                                       //    see Query Info Flags above or at <http://msdn.microsoft.com/workshop/networking/wininet/reference/constants/queryinfo_flags.asp>.
               var Buffer: string;                     // [in] A String buffer that receives the information.
               var lpdwIndex: DWORD                    // [in, out] Pointer to a zero-based header index used to enumerate multiple headers with
                                                       //      the same name. When calling the function, this parameter is the index of
                                                       //      the specified header to return. When the function returns, this parameter is
                                                       //      the index of the next header.
                                                       //      If the next index cannot be found, ERROR_HTTP_HEADER_NOT_FOUND is returned.

               ): boolean;
    function InternalHttpQueryInfoAsInt(
               hRequest: HINTERNET;                    // [in] HINTERNET request handle returned by InternalHttpOpenRequest or InternalInternetOpenUrl.
               dwInfoLevel: DWORD;                     // [in] Unsigned long integer value that contains a combination of an attribute to retrieve and the flags that modify the request. For a list of possible attribute and modifier values,
                                                       //    see Query Info Flags above or at <http://msdn.microsoft.com/workshop/networking/wininet/reference/constants/queryinfo_flags.asp>.
               var Buffer: dword;                      // [in] A unsigned integer  buffer that receives the information.
               var lpdwIndex: DWORD                    // [in, out] Pointer to a zero-based header index used to enumerate multiple headers with
                                                       //      the same name. When calling the function, this parameter is the index of
                                                       //      the specified header to return. When the function returns, this parameter is
                                                       //      the index of the next header.
                                                       //      If the next index cannot be found, ERROR_HTTP_HEADER_NOT_FOUND is returned.

               ): boolean;


    {  **** Displays a dialog box for the error that is passed to InternetErrorDlg, if an appropriate dialog box exists.
            If the FLAGS_ERROR_UI_FILTER_FOR_ERRORS flag is used, the function also checks the headers for any
            hidden errors and displays a dialog box if needed.

            -------- IMPORTANT Remarks of Function -----------
            Authentication errors are hidden because the call to HttpSendRequest will complete successfully. However,
            the status code would indicate that the proxy or server requires authentication.
            The FLAGS_ERROR_UI_FILTER_FOR_ERRORS flag causes the function to search the headers for status codes
            that indicate user input is needed.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/interneterrordlg.asp                   }
    function InternetErrorDlg(
               hWnd: HWND;                             // [in] Handle to the parent window for any needed dialog box.
                                                       //    This parameter can be NULL if no dialog box is needed.
               hRequest: HINTERNET;                    // [in, out] HINTERNET handle to the Internet connection used in the call to HttpSendRequest.
               dwError: DWORD;                         // [in] Error value for which to display a dialog box. This can be one of the following values:
                                                       //    ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR : Notifies the user of the zone crossing to and from a secure site.
                                                       //    ERROR_INTERNET_INCORRECT_PASSWORD     : Displays a dialog box requesting the user's name and password. (On Microsoft® Windows® 95, the function attempts to use any cached authentication information for the server being accessed before displaying a dialog box.)
                                                       //    ERROR_INTERNET_INVALID_CA             : Notifies the user that the Microsoft Win32® Internet function does not recognize the certificate authority that generated the certificate for this Secure Sockets Layer (SSL) site.
                                                       //    ERROR_INTERNET_POST_IS_NON_SECURE     : Displays a warning about posting data to the server through a nonsecure connection.
                                                       //    ERROR_INTERNET_SEC_CERT_CN_INVALID    : Indicates that the SSL certificate Common Name (host name field) is incorrect. Displays an Invalid SSL Common Name dialog box and lets the user view the incorrect certificate. Also allows the user to select a certificate in response to a server request.
                                                       //    ERROR_INTERNET_SEC_CERT_DATE_INVALID  : Tells the user that the SSL certificate has expired.
               dwFlags: DWORD;                         // [in] Unsigned long integer value that contains the action flags. This can be a combination of these values:
                                                       //    FLAGS_ERROR_UI_FILTER_FOR_ERRORS      : Scans the returned headers for errors. Call this flag after using HttpSendRequest. This option detects any hidden errors, such as an authentication error.
                                                       //    FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS   : If the function succeeds, stores the results of the dialog box in the Internet handle.
                                                       //    FLAGS_ERROR_UI_FLAGS_GENERATE_DATA    : Queries the Internet handle for needed information. The function constructs the appropriate data structure for the error. (For example, for Cert CN failures, the function grabs the certificate.)
                                                       //    FLAGS_ERROR_UI_SERIALIZE_DIALOGS      : Serializes authentication dialog boxes for concurrent requests on a password cache entry. The lppvData parameter should contain the address of a pointer to an INTERNET_AUTH_NOTIFY_DATA structure, and the client should implement a thread-safe, nonblocking callback function.
               var lppvData: Pointer                   // [in, out] Address of a pointer to a data structure.
                                                       //    The structure can be different for each error that needs to be handled.
               ): DWORD; virtual;                      // Returns one of the following values, or an error value otherwise.
                                                       //    ERROR_SUCCESS              : The function completed successfully. In the case of authentication this indicates that the user clicked the Cancel button.
                                                       //    ERROR_CANCELLED            : The function was canceled by the user.
                                                       //    ERROR_INTERNET_FORCE_RETRY : This indicates that the Win32 function needs to redo its request. In the case of authentication this indicates that the user clicked the OK button.
                                                       //    ERROR_INVALID_HANDLE       : The handle to the parent window is invalid.

  public
    {  **** Registers Global OnInternetCallBackEvent broker function as Callback and
    adds Calbacks list if successfully registered with given internet handle         }
    function RegisterCallback (hInet: HINTERNET;  pContext:PInternetCallbackContext; EventToHook:TInternet_Status_Callback_proc):boolean;
    {  **** Unregisters Previously Registeres Callback }
    function UnregisterCallBack (CallBackId:integer;hInet:HINTERNET):boolean;
    {  **** Adds one or more HTTP request headers to the HTTP request handle.
          -------- IMPORTANT Remarks of Function -----------
          HttpAddRequestHeaders appends additional, free-format headers to the HTTP request handle and
          is intended for use by sophisticated clients that need detailed control over the exact request
          sent to the HTTP server. Note that for basic HttpAddRequestHeaders, the application can pass
          in multiple headers in a single buffer. If the application is trying to remove or replace a header,
          only one header can be supplied in lpszHeaders.
    }
    {  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpaddrequestheaders.asp              }
    function InternalHttpAddRequestHeaders(
               hRequest: HINTERNET;                   // HINTERNET handle returned by a call to the HttpOpenRequest function.
               Headers: string;                       // A string variable containing the headers to append to the request.
                                                      //   Each header must be terminated by a CR/LF (carriage return/line feed) pair.
               dwModifiers: DWORD                     // Unsigned long integer value that contains the flags used to modify the semantics of this function.
                                                      //   Can be a combination of the following values:
                                                      //   HTTP_ADDREQ_FLAG_ADD        : Adds the header if it does not exist. Used with HTTP_ADDREQ_FLAG_REPLACE.
                                                      //   HTTP_ADDREQ_FLAG_ADD_IF_NEW : Adds the header only if it does not already exist; otherwise, an error is returned.
                                                      //   HTTP_ADDREQ_FLAG_COALESCE   : Coalesces headers of the same name.
                                                      //   HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA     : Coalesces headers of the same name. For example, adding "Accept: text/*" followed by "Accept: audio/*" with this flag results in the formation of the single header "Accept: text/*, audio/*". This causes the first header found to be coalesced. It is up to the calling application to ensure a cohesive scheme with respect to coalesced/separate headers.
                                                      //   HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON : Coalesces headers of the same name using a semicolon.
                                                      //   HTTP_ADDREQ_FLAG_REPLACE   : Replaces or removes a header. If the header value is empty and the header is found, it is removed. If not empty, the header value is replaced.
               ): boolean; virtual;                   // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.

  published
    property OnCallback:TInternet_Status_Callback_proc read fCallbackEvent write fCallbackEvent;
  end;

  { ******** TCustomInternetSesion **************
    Base Class of All Internet Components
    The API Internet Handle (hInet) property is read only but you can set with "setHandle" protected method in descendant classeses.
  }
  TCustomInternetComponent =  class (TComponent)
  private
    fLastAsyncError      : dword;
    fCanAsyncRead        : boolean;
    fApiInterface        : TINETApi_Intf;
    fApiOptions          : TINETApi_Options;
    fHandle              : HINTERNet;
    fLastProgress        : dword;
    fLastProgressMax     : dword;
    //fLastStatusCode      : dword;
    //fLastStatusText      : string;
    fLastElapsedTime     : TDatetime;
    fLastEstimatedTime   : TDatetime;
    fLastSpeed           : extended;
    fLastSpeedUnit       : string;
    fCallBackContext     : TInternetCallbackContext;
    fOnClosingConnection : TInternetOnClosingConnectionEvent;
    fOnConnectedToServer : TInternetOnConnectedEvent;
    fOnConnectingToServer: TInternetOnConnectingEvent;
    fOnConnectionClosed  : TInternetOnConnectionClosedEvent;
    fOnDetectingProxy    : TInternetOnDetectingProxyEvent;
    fOnHandleCreated     : TInternetOnHandleCreatedEvent;
    fOnHandleClosing     : TInternetOnHandleClosingEvent;
    fOnHostNameResolved  : TInternetOnHostNameResolvedEvent;
    fOnRedirect          : TInternetOnRedirectEvent;
    fOnRequestComplete   : TInternetOnRequestCompleteEvent;
    fOnRequestSent       : TInternetOnRequestSentEvent;
    fOnResolvingHostName : TInternetOnResolvingHostNameEvent;
    fOnResponse          : TInternetOnResponseEvent;
    fOnResponseReceived  : TInternetNotifyEvent;
    fOnWaitingForResponse: TInternetOnWaitingForResponseEvent;
    fOnProgress          : TInternetOnProgressEvent;
    fWindowHandle        : HWND;
  protected
    hAsyncHandle         : HINTERNET;
    function  getHandle:HINTERNET;virtual;
    procedure setHandle(p:HINTERNET);virtual;
    function  getCallBackContext:TInternetCallbackContext;virtual;
    procedure setCallBackContext(p:TInternetCallbackContext);virtual;
    function  get_pCallBackContext:PInternetCallbackContext;virtual;
    property CallbackContext:TInternetCallbackContext read getCallBackContext write setCallBackContext;
    property pCallbackContext:PInternetCallbackContext read get_pCallBackContext;

    procedure doOnClosingConnection(hInet:HINTERNET; dwContext:DWORD);virtual;                  //  Triggered when the connection to the server is Closing .                           [ API FLAG: INTERNET_STATUS_CLOSING_CONNECTION   ]
    procedure doOnConnectedToServer(hInet:HINTERNET; dwContext:DWORD ;SockAddr:pchar);virtual;  //  Triggered when Successfully connected to the socket address (pointed by SOCKADDR)  [ API FLAG: INTERNET_STATUS_CONNECTED_TO_SERVER  ]
    procedure doOnConnectingToServer (hInet:HINTERNET; dwContext:DWORD; SockAddr:pchar);virtual;  //  Triggered when Connecting to the socket address (pointed by SOCKADDR)              [ API FLAG: INTERNET_STATUS_CONNECTING_TO_SERVER ]
    procedure doOnConnectionClosed(hInet:HINTERNET; dwContext:DWORD);virtual;                   //  Triggered when Successfully closed the connection to the server.                   [ API FLAG: INTERNET_STATUS_CONNECTION_CLOSED    ]
    procedure doOnDetectingProxy(hInet:HINTERNET; dwContext:DWORD);virtual;                     //  Triggered when a proxy has been detected.                                          [ API FLAG: INTERNET_STATUS_DETECTING_PROXY      ]
    procedure doOnHandleClosing(hInet:HINTERNET; dwContext:DWORD);virtual;                       //  Triggered when a handle value has been terminated.                                 [ API FLAG: INTERNET_STATUS_HANDLE_CLOSING       ]
    procedure doOnHandleCreated(hInet:HINTERNET; dwContext:DWORD;                               //  Used by InternetConnect to indicate it has created the new handle.                 [ API FLAG: INTERNET_STATUS_HANDLE_CREATED       ]
                      pAsyncResult:LPINTERNET_ASYNC_RESULT); virtual;                           //    This lets the application call InternetCloseHandle from another thread, if the connect is taking too long.
    procedure doOnIntermediateResponse(hInet:HINTERNET; dwContext:DWORD;                        //  Triggered when an intermediate (100 level) status code Received  from the server.  [ API_FLAG: INTERNET_STATUS_INTERMEDIATE_RESPONSE]
                                       ResponseCode:dword);virtual;
    procedure doOnNameResolved(hInet:HINTERNET; dwContext:DWORD; IPAddr:pchar);virtual;         //  Triggered when Successfully found the IP address of the name                       [ API FLAG: INTERNET_STATUS_NAME_RESOLVED        ]
    procedure doOnWaitingForResponse(hInet:HINTERNET; dwContext:DWORD);virtual;                 //  TRiggered when start to wait for the server to respond to a request.               [ API FLAG: INTERNET_STATUS_RECEIVING_RESPONSE   ]
    procedure doOnRedirect(hInet:HINTERNET; dwContext:DWORD; newURL :pchar);virtual;            //  Triggered when an HTTP request is about to automatically redirect the request.     [ API FLAG: INTERNET_STATUS_REDIRECT             ]
                                                                                                //  At this point, the application can read any data returned by the server with the redirect response and can query the response headers.
                                                                                                //   It can also cancel the operation by closing the handle. This callback is not made if the original request specified INTERNET_FLAG_NO_AUTO_REDIRECT.
    procedure doOnRequestComplete(hInet:HINTERNET; dwContext:DWORD;                             //  Triggered when an asynchronous operation has been completed.                       [ API FLAG: INTERNET_STATUS_REQUEST_COMPLETE     ]
                      pAsyncResult:LPINTERNET_ASYNC_RESULT);virtual;
    procedure doOnRequestSent(hInet:HINTERNET; dwContext:DWORD; pReqLength: pdword);virtual;    //  Triggered when an information request successfully sent to the server.             [ API FLAG: INTERNET_STATUS_REQUEST_SENT         ]
    procedure doOnResolvingName(hInet:HINTERNET; dwContext:DWORD;pIPAddr: pchar);virtual;       //  Triggered when looking up a IP address of the name                                 [ API FLAG: INTERNET_STATUS_RESOLVING_NAME       ]
    procedure doOnResponseReceived(hInet:HINTERNET; dwContext:DWORD;pResLength: pdword);virtual;//  Triggered when a response successfully received from the server.                   [ API FLAG: INTERNET_STATUS_RESPONSE_RECEIVED    ]
    procedure doOnSendingRequest(hInet:HINTERNET; dwContext:DWORD);virtual;                     //  Triggered when sending an information request to the server.                       [ API FLAG: INTERNET_STATUS_SENDING_REQUEST      ]
    procedure doOnStateChange(hInet:HINTERNET; dwContext:DWORD;pExtraInfo:pdword);virtual;      //  Triggered when moved between a secure (HTTPS) and a nonsecure (HTTP) site.         [ API FLAG: INTERNET_STATUS_STATE_CHANGE         ]
    procedure doOnCookieSent(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;        //  Undocumented! [API FLAG: INTERNET_STATUS_COOKIE_SENT          ]
    procedure doOnCookieRecieved(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;    //  Undocumented! [API FLAG: INTERNET_STATUS_COOKIE_RECEIVED      ]
    procedure doOnPrivacyImpacted(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;   //  Undocumented! [API FLAG: INTERNET_STATUS_PRIVACY_IMPACTED     ]
    procedure doOnP3PHeader(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;         //  Undocumented! [API FLAG: INTERNET_STATUS_P3P_HEADER           ]
    procedure doOnP3PpolicyRef(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;      //  Undocumented! [API FLAG: INTERNET_STATUS_P3P_POLICYREF        ]
    procedure doOnCookieHistory(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);virtual;     //  Undocumented! [API FLAG: INTERNET_STATUS_COOKIE_HISTORY       ]
    procedure doOnProgress(hInet:HINTERNET;Progress,ProgressMax, StatusCode: Cardinal;          // Triggered whenever a progress related event occurred. Thi is a derived event so there is no coressponding Api Flag.
        StatusText: string; ElapsedTime, EstimatedTime:TDatetime;Speed :extended;
        SpeedUnit: string);overload;virtual;
    procedure doOnProgress(hInet:HINTERNET;dwContext:DWORD;StatusCode: Cardinal;StatusText: string);overload;virtual;

    // Status Callback Broker
    procedure doOnStatusCallback (hInet:HINTERNET;dwContext:DWORD;dwInternetStatus:DWORD;lpvStatusInformation:pointer;
                                  dwStatusInformationLength:DWORD);virtual;
    //Manupulators of Event properties
    function  getOnClosingConnection:TInternetOnClosingConnectionEvent;virtual;
    procedure setOnClosingConnection(p:TInternetOnClosingConnectionEvent);virtual;
    function  getOnConnectedToServer:TInternetOnConnectedEvent;virtual;
    procedure setOnConnectedToServer(p:TInternetOnConnectedEvent);virtual;
    function  getOnConnectingToServer:TInternetOnConnectingEvent;virtual;
    procedure setOnConnectingToServer(p:TInternetOnConnectingEvent);virtual;
    function  getOnConnectionClosed:TInternetOnConnectionClosedEvent;virtual;
    procedure setOnConnectionClosed(p:TInternetOnConnectionClosedEvent);virtual;
    function  getOnDetectingProxy:TInternetOnDetectingProxyEvent;virtual;
    procedure setOnDetectingProxy(p:TInternetOnDetectingProxyEvent);virtual;
    function  getOnHandleCreated:TInternetOnHandleCreatedEvent;virtual;
    procedure setOnHandleCreated(p:TInternetOnHandleCreatedEvent);virtual;
    function  getOnHandleClosingEvent:TInternetOnHandleClosingEvent;virtual;
    procedure setOnHandleClosingEvent(p:TInternetOnHandleClosingEvent);virtual;
    function  getOnHostNameResolvedEvent:TInternetOnHostNameResolvedEvent;virtual;
    procedure setOnHostNameResolvedEvent(p:TInternetOnHostNameResolvedEvent);virtual;
    function  getOnRedirect:TInternetOnRedirectEvent;virtual;
    procedure setOnRedirect(p:TInternetOnRedirectEvent);virtual;
    function  getOnRequestComplete:TInternetOnRequestCompleteEvent;virtual;
    procedure setOnRequestComplete(p:TInternetOnRequestCompleteEvent);virtual;
    function  getOnRequestSent:TInternetOnRequestSentEvent;virtual;
    procedure setOnRequestSent(p:TInternetOnRequestSentEvent);virtual;
    function  getOnResolvingHostName:TInternetOnResolvingHostNameEvent;virtual;
    procedure setOnResolvingHostName(p:TInternetOnResolvingHostNameEvent);virtual;
    function  getOnResponse:TInternetOnResponseEvent;virtual;
    procedure setOnResponse(p:TInternetOnResponseEvent);virtual;
    function  getOnResponseReceived:TInternetNotifyEvent;virtual;
    procedure setOnResponseReceived(p:TInternetNotifyEvent);virtual;
    function  getOnWaitingForResponse:TInternetOnWaitingForResponseEvent;virtual;
    procedure setOnWaitingForResponse(p:TInternetOnWaitingForResponseEvent);virtual;
    function  getOnProgress:TInternetOnProgressEvent;virtual;
    procedure setOnProgress(p:TInternetOnProgressEvent);virtual;
    procedure WndProc(var Message: TMessage);virtual;
  public
    property WindowHandle:HWND read fWindowHandle write fWindowHandle; //Handle for WinApi Messaging;
    property ApiInterface:TINETApi_Intf read fApiInterface;        // Raw API Interface to WININET. Please Use very carefully...
    property ApiOptions  :TINETApi_Options read fApiOptions;

    constructor Create(aOwner:TComponent);override;
    destructor  Destroy;override;
  published
    property OnClosingConnection:TInternetOnClosingConnectionEvent read getOnClosingConnection write setOnClosingConnection;
    property OnConnectedToServer:TInternetOnConnectedEvent read getOnConnectedToServer write setOnConnectedToServer;
    property OnConnectingToServer:TInternetOnConnectingEvent read getOnConnectingToServer write setOnConnectingToServer;
    property OnConnectionClosed:TInternetOnConnectionClosedEvent read getOnConnectionClosed write setOnConnectionClosed;
    property OnDetectingProxy:TInternetOnDetectingProxyEvent read getOnDetectingProxy write setOnDetectingProxy;
    property OnHandleCreated:TInternetOnHandleCreatedEvent read getOnHandleCreated write setOnHandleCreated;
    property OnHandleClosing:TInternetOnHandleClosingEvent read getOnHandleClosingEvent write setOnHandleClosingEvent;
    property OnHostNameResolved:TInternetOnHostNameResolvedEvent read getOnHostNameResolvedEvent write setOnHostNameResolvedEvent;
    property OnRedirect:TInternetOnRedirectEvent read getOnRedirect write setOnRedirect;
    property OnRequestComplete:TInternetOnRequestCompleteEvent read getOnRequestComplete write setOnRequestComplete;
    property OnRequestSent:TInternetOnRequestSentEvent read getOnRequestSent write setOnRequestSent;
    property OnResolvingHostName:TInternetOnResolvingHostNameEvent read getOnResolvingHostName write setOnResolvingHostName;
    property OnResponse:TInternetOnResponseEvent read getOnResponse write setOnResponse;
    property OnResponseReceived:TInternetNotifyEvent read getOnResponseReceived write setOnResponseReceived;
    property OnWaitingForResponse:TInternetOnWaitingForResponseEvent read getOnWaitingForResponse write setOnWaitingForResponse;

    property OnProgress:TInternetOnProgressEvent read getOnProgress write setOnProgress;

  end;


  { ******** TCustomInternetSesion **************
    This class creates and initializes one or more simultaneous Internet sessions and, if necessary, describes your connection to a proxy server.
    If your Internet connection must be maintained for the duration of an application, you can create a TCustomInternetSesion or its descendants
    as a member of the class TApplication.Once you have established an Internet session (By calling Open method or setting Active property True),
    you can call OpenURL Method to access internet resources.
    TCustomInternetSesion then parses the URL for you by calling the global function ParseURL. Regardless of its protocol type,
    TCustomInternetSesion interprets the URL and manages it for you. It can handle requests for local files identified with the URL resource,
    file://. OpenURL will return a pointer to a TFileStream object if the name you pass it is a local file.

    If you open a URL on an Internet server using OpenURL, you can read information from the site. If you want to perform service-specific
    actions on files located on a server, such as HTTP, you must establish the appropriate connection with that server.
    To open a particular kind of connection directly to a particular service, use the following method:
        * GetHttpConnection to open a connection to an HTTP service.
    QueryOption and SetOption allow you to set the query options of your session, such as time-out values, number of retries, and so on.
    During an Internet session, a transaction such as a search or data download can take appreciable time. The user might want to continue working,
    or might want to have status information about the progress of the transaction. To handle this problem, TCustomInternetSesion provides for searches and
    data transfer to occur asychronously, allowing the user to perform other tasks while waiting for the transfer to complete.
    If you want to provide the user with status information, or if you want to handle any operations asynchronously, three conditions must be set:
     * Asynchronous property must be set to "True".
     * Context property (an untyped pointer) must be set to a nonzero value.
     * You must establish a call back function by calling EnableStatusCallback
        Use the overridable method OnStatusCallback to get status information on asynchronous retrieval.
        To use this overridable method, you must derive your own class from TCustomInternetSesion.
    TCustomInternetSesion will throw an ENotSupportedException for unsupported service types.
    Only the HTTP and FILE service types are currently supported.
  }
  TCustomInternetSession = class (TCustomInternetComponent)
  private
    fAsync           : boolean;
    fOffline         : boolean;
    fFromCache       : boolean;
    fUserAgent       : string;
    fCurrentUser     : string;
    fOnProgress      : TInternetOnProgressEvent;
    fProxy           : string;
    fAccessType      : TInternetAccessTypes;
    fProxyByPassList : TStringList;
    fisStatusCallbacksEnabled :boolean;
    fConnections     : TList;
  protected
    //Property Processor Methods
    function  getCurrentUser:string;virtual;
    procedure setCurrentUser(p:string);virtual;
    function  getActive:boolean;virtual;
    procedure setActive(p:boolean);virtual;
    function  getServiceType:TInternetHandleTypes;virtual;
    function  getEnableStatusCallback:boolean;virtual;
    procedure setEnableStatusCallback(p:boolean);virtual;
    function  getOffline:boolean;virtual;
    procedure setOffline(p:boolean);virtual;
    function  getAsync:boolean;virtual;
    procedure setAsync(p:boolean);virtual;
    function  getFromCache:boolean;virtual;
    procedure setFromCache(p:boolean);virtual;
    function  getUserAgent:string;virtual;
    procedure setUserAgent(p:string);virtual;
    function  GetDefaultUserAgent: string;virtual;
    function  getAccessType:TInternetAccessTypes;virtual;
    procedure setAccessType(p:TInternetAccessTypes);virtual;
    function  getApiAccessType:dword;virtual;
    function  getApiFlags:dword;virtual;
    function  getProxyByPassList:TStrings;virtual;
    procedure setProxyByPassList(p:TStrings);virtual;
    function  getProxy:string;virtual;
    procedure setProxy(p:string);virtual;
    function  getConnection(index:integer):TCustomInternetConnection;virtual;
    procedure setConnection(index:integer;p:TCustomInternetConnection);virtual;
    procedure AddConnection(aConnection:TCustomInternetConnection);virtual;
    procedure RemoveConnection(aConnection:TCustomInternetConnection);virtual;
    property Active:boolean read getActive write setActive;         // Set this property true to activate session and false to close active session
    property Asynchronous:boolean read getAsync write setAsync;     // If true session allows non-blocking Asynchronous transactions.Note that Context property must be set to non-null value for non-blocking operartions
    property FromCache:boolean read getFromCache write setFromCache;// Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned.
    property OffLine:boolean read getOffline write setOffline;      // Identical to From Cache
    property ServiceType:TInternetHandleTypes read getServiceType;  // Type of current service from the Internet handle
    property EnableStatusCallback:boolean                           // This Property controls status callbacks.
             read getEnableStatusCallback                           //    When handling status callback, you can provide status about the progress of the operation, such as resolving name, connecting to a server, and so on, in the status bar of the application.
             write setEnableStatusCallback;                         //    Displaying operation status is desirable during a long-term operation.
    property OnProgress:TInternetOnProgressEvent read fOnProgress write fOnProgress;


  public
    property hSession: HINTERNET read getHandle;
    property Connections[index:integer]:TCustomInternetConnection     // Array of active connections that are owned by this session
       read getConnection write setConnection;
    function  ConnectionCount:integer;
    procedure Open;virtual;                                     // Activates Internet Session.
    procedure Close;virtual;                                    // Closes Active Session.
    function  OpenURL(                                  // This method sends the specified request to the HTTP server and allows the client to specify additional RFC822, MIME, or HTTP headers to send along with the request.
          const URL:string;                                         // URL to begin reading. Only URLs beginning with file: or http: are supported.
          const dwContext:dword;                                    // Specifies an application-defined value passed with the returned handle in callback.
          const dwFlags:dword;                                      // All Flags of TINETApi_Intf.InternalInternetOpenUrl Function can be used. Default is INTERNET_FLAG_TRANSFER_ASCII.
          const Headers:string;                                      // that contains the headers to be sent to the HTTP server. (For more information, see the description of the Headers parameter in the InternalHttpSendRequest function of API Interface Object.)
          ReceiveStream:TStream
          ):boolean;virtual;                                          // Returns true if successfull.

    constructor Create(aOwner:TComponent);override;             // Creates new Object Instance
    destructor  Destroy;override;                               // Releases this object and its allocated memory
  published
    property UserAgent:string read getUserAgent write setUserAgent;
    property AccessType: TInternetAccessTypes read getAccessType write setAccessType;
    property Proxy:string read getProxy write setProxy;
    property ProxyByPassList:TStrings read getProxyByPassList write setProxyByPassList;
    property CurrentUser:string read getCurrentUser write setCurrentUser;  // Every user has its  own cookie database...cool :)
  end;
  TInternetSession = class (TCustomInternetSession)
  private
  protected
  public
    property ApiInterface;    // Raw API Interface to WININET. Please Use very carefully...
  published
    property Active;           // Set this property true to activate session and false to close active session
    property Asynchronous;     // If true session allows non-blocking Asynchronous transactions.Note that Context property must be set to non-null value for non-blocking operartions
    property FromCache;        // Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned.
    property OffLine;          // Identical to From Cache
    property ServiceType;      // Type of current service from the Internet handle
    property EnableStatusCallback; // This Property controls status callbacks.
                                   //    When handling status callback, you can provide status about the progress of the operation, such as resolving name, connecting to a server, and so on, in the status bar of the application.
                                   //    Displaying operation status is desirable during a long-term operation.
    property OnProgress;

  end;
  TCustomInternetConnection = class(TCustomInternetComponent)
  private
    fSession     : TCustomInternetSession;
    fScheme      : TInternetSchemes;
    fServer      : string;
    fPort        : dword;
    fServiceType : TInternetConnectionTypes;
    fUsername    : string;
    fPassword    : string;
    fCookieHandler : THTTPCookies;
    fCookieHandling: THTTPCookieHandlingTypes;
    fRedirecting : boolean;
    fRequests    : TList;
    //fContext     : pointer;
  protected
    function  getRedirecting:boolean;virtual;
    procedure setRedirecting(p:boolean);virtual;
    function  getApiConnectionType:dword;virtual;
    function  getApiFlags:dword;virtual;
    function  getConnected:boolean;virtual;
    procedure setConnected(p:boolean);virtual;
    function  getSessionHandle:HINTERNET;virtual;
    function  getSession:TCustomInternetSession;virtual;
    procedure setSession(p:TCustomInternetSession);virtual;
    function  getScheme:TInternetSchemes;virtual;
    procedure setScheme(p:TInternetSchemes);virtual;

    function  getServer:string;virtual;
    procedure setServer(p:string);virtual;
    function  getPort:dword;virtual;
    procedure setPort(p:dword);virtual;
    function  getServiceType:TInternetConnectionTypes;virtual;
    procedure setServiceType(p:TInternetConnectionTypes);virtual;
    function  getUserName:string;virtual;
    procedure setUserName(p:string);virtual;
    function  getPassword:string;virtual;
    procedure setPassword(p:string);virtual;
    function  getConnectionContext:pointer;virtual;
    procedure setConnectionContext(p:pointer);virtual;
    procedure getCookies(url:string;var hdqCookie:string);virtual;
    procedure setCookies(Url:string;hdrCookies:TStrings);virtual;
    function  get_opCookieHandling:THTTPCookieHandlingTypes;virtual;
    procedure set_opCookieHandling(p:THTTPCookieHandlingTypes);virtual;
    function  getRequest(index:integer):TCustomInternetRequest;virtual;
    procedure setRequest(index:integer;p:TCustomInternetRequest);virtual;
    procedure AddRequest(aRequest:TCustomInternetRequest);virtual;
    procedure RemoveRequest(aRequest:TCustomInternetRequest);virtual;
  public
    property Requests[index:integer]:TCustomInternetRequest read getRequest write setRequest;
    property Redirecting:boolean read getRedirecting write setRedirecting;
    property hSession:HINTERNET read getSessionHandle;                            // A Pointer to API Handle Session which this Connection belong to. Use this handle to make direct calls to WININET API.
    property hConnection:HINTERNET read getHandle;                                // A Pointer to API Handle of this Connection. Use this handle to make direct calls to WININET API.
    property ConnectionContext: pointer                                           // A Pointer to a value that contains the application-defined value that associates this operation with any application data.
        read getConnectionContext write setConnectionContext;
    function RequestCount:integer;virtual;
    procedure Connect;virtual;                                                    // Tries to Connect target Server and id successful sets the Connected property true. Fires related events.
    //procedure Open(ReceiveStream:TStream);virtual;abstract;                       // This abstract method will be implemented in derived classes and will allow to access web resources in one way.
    procedure Disconnect;virtual;                                                 // Disconnects from server (if connected) and releases all allocated resources, clears temp files, fires related events.
    constructor Create(aOwner:TComponent);override;                               // Creates a new instance of TInternet Connection object. Do not use this constructor directly because it is an abstract class. Use one of its descendants (TInternetHTTPRequest etc.)
    destructor  Destroy;override;                                                 // releases an instance.
  published
    property Cookies : THTTPCookies read fCookieHandler;
    property Connected: boolean read getConnected write setConnected;             // Controls &| shows connection state
    property Session: TCustomInternetSession read getSession write setSession;    // This object requires a valid Internet Session. See TInternetSession class...
    property Scheme:TInternetSchemes read getScheme write setScheme;              // Scheme part of current URL.
    property Server: string read getServer write setServer;                       // DNS Name or IP Address of server to connect to
    property Port: dword read getPort write setPort;                              // Port Number of Target Server
    property Service: TInternetConnectionTypes                                    // Type of Protocol (only HTTP, FTP or GOPHER protocols supported)
         read getServiceType write setServiceType;

    property UserName: string read getUserName write setUserName;                 // Contains Username if auth requiered such as for ftp sessions
    property Password: string read getPassword write setPassword;                 // Contains Password if auth requiered such as for ftp sessions
    property opCookieHandling:THTTPCookieHandlingTypes                                  // [ API FLAG: INTERNET_FLAG_NO_COOKIES               ]
         read get_opCookieHandling write set_opCookieHandling;                          // Determines what kind of cookie handling will done.
  end;
  TInternetConnection = class (TCustomInternetConnection)
  private
  protected
  public
  published
  end;


  TInternetDataReader = class (TThread)
  private
    fContext:dword;
    fRequest:TCustomInternetRequest;
    progress,progressMax,TotalRead:dword;
  protected
    procedure triggerProgessEvent;
  public

    procedure execute;override;
    constructor create(request:TCustomInternetRequest;dwContext:dword);
    destructor destroy;override;
  end;

  TCustomInternetRequest = class (TCustomInternetComponent)
  private
    fConnection       : TCustomInternetConnection;
    fObjectName       : string;
    fExtraInfo        : string;
    fonLoaded         : TInternetOnLoadedEvent;
    fscheme           : TInternetSchemes;
    fFileToUpload     : string;
    furl              : string;
    fNewURL           :string;


  protected
    fAsyncStatus      : TAsyncStatus;
    AsyncReader       : TInternetDataReader;
    fReceiverStream   : TStream;
    function  getActive:boolean;virtual;
    procedure setActive(p:boolean);virtual;
    function  getConnection:TCustomInternetConnection;virtual;
    procedure setConnection(p:TCustomInternetConnection);virtual;
    function  getURL:string;virtual;
    procedure setURL(p:string);virtual;
    function  getScheme:TInternetSchemes;virtual;
    procedure setScheme(p:TInternetSchemes);virtual;
    function  getServer:string;virtual;
    procedure setServer(p:string);virtual;
    function  getPort:dword;virtual;
    procedure setPort(p:dword);virtual;
    function  getServiceType:TInternetConnectionTypes;virtual;
    procedure setServiceType(p:TInternetConnectionTypes);virtual;
    function  getUserName:string;virtual;
    procedure setUserName(p:string);virtual;
    function  getPassword:string;virtual;
    procedure setPassword(p:string);virtual;
    function  getObjectName:string;virtual;
    procedure setObjectName(p:string);virtual;
    function  getExtraInfo:string;virtual;
    procedure setExtraInfo(p:string);virtual;
    function  getURLComponents:TURL_Components;
    function  getOnLoaded:TInternetOnLoadedEvent;virtual;
    procedure setOnLoaded(p:TInternetOnLoadedEvent);virtual;
    procedure doOnReaderTerminate(Sender:TObject);
    procedure Loaded;override;
  public
    property  AsyncStatus:TAsyncStatus read fAsyncStatus;
    property  hRequest:HINTERNET read getHandle;
    procedure OpenRequest;virtual;abstract;
    procedure SendRequest(ReceiveStream:TStream);virtual;abstract;
    procedure CloseRequest;virtual;abstract;
    procedure CancelAsyncRequest;virtual;
  published
    property Active:boolean read getActive write setActive;
    property Connection:TCustomInternetConnection read getConnection write setConnection;
    property Scheme:TInternetSchemes read getScheme write setScheme;              // Scheme part of current URL.
    property Server: string read getServer write setServer;                       // DNS Name or IP Address of server to connect to
    property Port: dword read getPort write setPort;                              // Port Number of Target Server
    property Service: TInternetConnectionTypes                                    // Type of Protocol (only HTTP, FTP or GOPHER protocols supported)
         read getServiceType write setServiceType;

    property UserName: string read getUserName write setUserName;                 // Contains Username if auth requiered such as for ftp sessions
    property Password: string read getPassword write setPassword;                 // Contains Password if auth requiered such as for ftp sessions

    property ObjectName:string read getObjectName write setObjectName;
    property ExtraInfo: string read getExtraInfo write setExtraInfo;              // Contains last part of url other than scheme, host, port or object name (eg ?foo or #foo)
    property URL:string read getURL write setURL;                                 // This property works in two ways. If URL set it sets scheme, host, port, objectname and extrainfo properties. if one of scheme, host, port, objectname or extrainfo properties set they combine the URL property.
    property FileToUpload:string read fFileToUpload write fFileToUpload;
    //events
    property OnLoaded: TInternetOnLoadedEvent read getOnLoaded write setOnLoaded; // Triggered when an operation completed.

  end;
  TInternetHTTPRequest = class (TCustomInternetRequest)
  private
    fMethod           : TInternetHttpMethods;
    fVersion          : HTTP_VERSION_INFO;
    fReferrer         : string;
    fAcceptTypes      : TStringList;
    fHttpFlags        : dword;
    //fCookieHandling   : THTTPCookieHandlingTypes;
    //fHttpHandle       : HINTERNET;
    fPostData         : string;
    fDocSize          : dword;
    fLastResponseCode : dword;
    // Internal Buffers of Header properties. Valuest kept in these buffers as long as connected property is false.
    fhdqAccepTypes          : string;
    fhdqAcceptCharSet       : string;
    fhdqAcceptEncoding      : string;
    fhdqAcceptLanguage      : string;
    fhdqAcceptRanges        : string;
    fhdqAuthorization       : string;
    fhdqExpect              : string;
    fhdqIfMatch             : string;
    fhdqIfModifiedSince     : string;
    fhdqIfNoneMatch         : string;
    fhdqIfRange             : string;
    fhdqIfUnmodifiedSince   : string;
    fhdqMaxForwards         : string;
    fhdqPragma              : string;
    fhdqProxyAuthorization  : string;
    fhdqProxyConnection     : string;
    fhdqRange               : string;
    fhdqRawHeaders          : TStringList;
    fhdqRetryAfter          : string;
    fhdqCookie              : string;
    fhdqTransferEncoding    : string;
    fhdqUnlessModifiedSince : string;
    fhdqUserAgent           : string;
    fhdqVia                 : string;
    fPostEnctype            : string;
    fUploadData             : pchar;
    fUploadDataSize         : dword;
    fRedirected             : boolean;

    fhdrEchoHeaders         : TStringList;
    fhdrRawHeaders          : TStringList;
    fhdrCookies             : TStringList;
  protected
    procedure doOnIntermediateResponse(hInet:HINTERNET; dwContext:DWORD;                        //  Triggered when an intermediate (100 level) status code Received  from the server.  [ API_FLAG: INTERNET_STATUS_INTERMEDIATE_RESPONSE]
                                       ResponseCode:dword);override;

    procedure doOnResponseReceived(hInet:HINTERNET; dwContext:DWORD;pResLength: pdword);override;//  Triggered when a response successfully received from the server.                   [ API FLAG: INTERNET_STATUS_RESPONSE_RECEIVED    ]
    procedure doOnRedirect(hInet:HINTERNET; dwContext:DWORD; newURL :pchar);override;
    procedure setScheme(p:TInternetSchemes);override;
    procedure setServer(p:string);override;
    procedure setConnection(p:TCustomInternetConnection);override;
    //function  getHttpHandle:HINTERNET;virtual;
    //procedure setHttpHandle(p:HINTERNET);virtual;
    function  gethConnection:pointer;virtual;
    function  getMethod:TInternetHttpMethods;virtual;
    procedure setMethod(p:TInternetHttpMethods);virtual;
    function  getVersion:HTTP_VERSION_INFO;virtual;
    procedure setVersion(p:HTTP_VERSION_INFO);virtual;
    function  getReferrer:string;virtual;
    procedure setReferrer(p:string);virtual;
    function  getAcceptTypes:TStrings;virtual;
    procedure setAcceptTypes(p:TStrings);virtual;
    function  getHttpContext:pointer;virtual;
    procedure setHttpContext(p:pointer);virtual;
    function  getApiHttpFlags:dword;virtual;
    function  AddRequestHeader(API_FLAG: dword; headerValue:string):boolean;virtual;
    procedure GetRequestHeaderProp(API_FLAG: dword; var FuncResult:string;pInternalPropVar:pointer);virtual;
    procedure GetResponseHeaderProp(API_FLAG: dword; var FuncResult:string;pInternalPropVar:pointer);virtual;
    procedure GetResponseIntHeaderProp(API_FLAG: dword; var FuncResult:dword;pInternalPropVar:pointer);virtual;
    procedure SetHeaderProp(API_FLAG: dword; var InternalPropVar:string; NewValue:string);virtual;
    function  getPostData:string;virtual;
    procedure setPostData(p:string);virtual;
    procedure clearHeaderBuffers;virtual;
    procedure flashHeaderBuffers;virtual;
    procedure setReceiverStream(aStream:TStream);virtual;
    function  getCookieURL:string;virtual;

    {OPTIONS [FLAGS]}
    function  get_opCacheIfNetFail:boolean;virtual;            // [ Set API FLAG: NET_FLAG_CACHE_IF_NET_FAIL             ]
    procedure set_opCacheIfNetFail(p:boolean);virtual;         // [ Get API FLAG: NET_FLAG_CACHE_IF_NET_FAIL             ]
    function  get_opHyperlink:boolean;virtual;                 // [ Get API FLAG: INTERNET_FLAG_HYPERLINK                ]
    procedure set_opHyperlink(p:boolean);virtual;              // [ Set API FLAG: INTERNET_FLAG_HYPERLINK                ]
    function  get_opIgnoreCertCNInvalid:boolean;virtual;       // [ Get API FLAG: INTERNET_FLAG_IGNORE_CERT_CN_INVALID   ]
    procedure set_opIgnoreCertCNInvalid(p:boolean);virtual;    // [ Set API FLAG: INTERNET_FLAG_IGNORE_CERT_CN_INVALID   ]
    function  get_opIgnoreCertDateInvalid:boolean;virtual;     // [ Get API FLAG: INTERNET_FLAG_IGNORE_CERT_DATE_INVALID ]
    procedure set_opIgnoreCertDateInvalid(p:boolean);virtual;  // [ Set API FLAG: INTERNET_FLAG_IGNORE_CERT_DATE_INVALID ]
    function  get_opIgnoreRedirectToHTTP:boolean;virtual;      // [ Get API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  ]
    procedure set_opIgnoreRedirectToHTTP(p:boolean);virtual;   // [ Set API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  ]
    function  get_opIgnoreRedirectToHTTPS:boolean;virtual;     // [ Get API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS ]
    procedure set_opIgnoreRedirectToHTTPS(p:boolean);virtual;  // [ Set API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS ]
    function  get_opKeepConnection:boolean;virtual;            // [ Get API FLAG: INTERNET_FLAG_KEEP_CONNECTION          ]
    procedure set_opKeepConnection(p:boolean);virtual;         // [ Set API FLAG: INTERNET_FLAG_KEEP_CONNECTION          ]
    function  get_opNeedFile:boolean;virtual;                  // [ Get API FLAG: INTERNET_FLAG_NEED_FILE                ]
    procedure set_opNeedFile(p:boolean);virtual;               // [ Set API FLAG: INTERNET_FLAG_NEED_FILE                ]
    function  get_opNoAutoAuth:boolean;virtual;                // [ Get API FLAG: INTERNET_FLAG_NO_AUTH                  ]
    procedure set_opNoAutoAuth(p:boolean);virtual;             // [ Set API FLAG: INTERNET_FLAG_NO_AUTH                  ]
    function  get_opNoAutoRedirect:boolean;virtual;            // [ Get API FLAG: INTERNET_FLAG_NO_AUTO_REDIRECT         ]
    procedure set_opNoAutoRedirect(p:boolean);virtual;         // [ Set API FLAG: INTERNET_FLAG_NO_AUTO_REDIRECT         ]
    function  get_opNoCacheWrite:boolean;virtual;              // [ Get API FLAG: INTERNET_FLAG_NO_CACHE_WRITE           ]
    procedure set_opNoCacheWrite(p:boolean);virtual;           // [ Set API FLAG: INTERNET_FLAG_NO_CACHE_WRITE           ]
    function  get_opCookieHandling:THTTPCookieHandlingTypes;virtual;   // [ Get API FLAG: INTERNET_FLAG_NO_COOKIES       ]
    procedure set_opCookieHandling(p:THTTPCookieHandlingTypes);virtual;// [ Set API FLAG: INTERNET_FLAG_NO_COOKIES       ]
    function  get_opDisableCookieDialogbox:boolean;virtual;    // [ Get API FLAG: INTERNET_FLAG_NO_UI                    ]
    procedure set_opDisableCookieDialogbox(p:boolean);virtual; // [ Set API FLAG: INTERNET_FLAG_NO_UI                    ]
    function  get_opForceProxyToReload:boolean;virtual;        // [ Get API FLAG: INTERNET_FLAG_PRAGMA_NOCACHE           ]
    procedure set_opForceProxyToReload(p:boolean);virtual;     // [ Set API FLAG: INTERNET_FLAG_PRAGMA_NOCACHE           ]
    function  get_opForceReload:boolean;virtual;               // [ Get API FLAG: INTERNET_FLAG_RELOAD                   ]
    procedure set_opForceReload(p:boolean);virtual;            // [ Set API FLAG: INTERNET_FLAG_RELOAD                   ]
    function  get_opResynchronize:boolean;virtual;             // [ Get API FLAG: INTERNET_FLAG_RESYNCHRONIZE            ]
    procedure set_opResynchronize(p:boolean);virtual;          // [ Set API FLAG: INTERNET_FLAG_RESYNCHRONIZE            ]
    function  get_opSecure:boolean;virtual;                    // [ Get API FLAG: INTERNET_FLAG_SECURE                   ]
    procedure set_opSecure(p:boolean);virtual;                 // [ Set API FLAG: INTERNET_FLAG_SECURE                   ]

    function  get_hdqAcceptTypes:string;                       // [HTTP_QUERY_ACCEPT] : Retrieves the acceptable media types for the response.
    procedure set_hdqAcceptTypes(p:string);                    // [HTTP_QUERY_ACCEPT] : Sets the acceptable media types for the response.
    function  get_hdqAcceptCharSet:string;                     // [HTTP_QUERY_ACCEPT_CHARSET] : Retrieves the acceptable character sets for the response.
    procedure set_hdqAcceptCharSet(p:string);                  // [HTTP_QUERY_ACCEPT_CHARSET] : Sets the acceptable character sets for the response.
    function  get_hdqAcceptEncoding:string;                    // [HTTP_QUERY_ACCEPT_ENCODING] : Retrieves the acceptable content-coding values for the response.
    procedure set_hdqAcceptEncoding(p:string);                 // [HTTP_QUERY_ACCEPT_ENCODING] : Sets the acceptable content-coding values for the response.
    function  get_hdqAcceptLanguage:string;                    // [HTTP_QUERY_ACCEPT_LANGUAGE] : Retrieves the acceptable natural languages for the response.
    procedure set_hdqAcceptLanguage(p:string);                 // [HTTP_QUERY_ACCEPT_LANGUAGE] : Sets the acceptable natural languages for the response.
    function  get_hdqAcceptRanges:string;                      // [HTTP_QUERY_ACCEPT_RANGES] : Retrieves the types of range requests that are accepted for a resource.
    procedure set_hdqAcceptRanges(p:string);                   // [HTTP_QUERY_ACCEPT_RANGES] : Sets the types of range requests that are accepted for a resource.
    function  get_hdqAuthorization:string;                     // [HTTP_QUERY_AUTHORIZATION] : Retrieves the authorization credentials used for a request.
    procedure set_hdqAuthorization(p:string);                  // [HTTP_QUERY_AUTHORIZATION] : Sets the authorization credentials used for a request.
    function  get_hdqExpect:string;                            // [HTTP_QUERY_EXPECT] : Retrieves the Expect header, which indicates whether the client application should expect 100 series responses.
    procedure set_hdqExpect(p:string);                         // [HTTP_QUERY_EXPECT] : Sets the Expect header, which indicates whether the client application should expect 100 series responses.
    function  get_hdqIfMatch:string;                           // [HTTP_QUERY_IF_MATCH] : Retrieves the contents of the If-Match request-header field.
    procedure set_hdqIfMatch(p:string);                        // [HTTP_QUERY_IF_MATCH] : Sets the contents of the If-Match request-header field.
    function  get_hdqIfModifiedSince:string;                   // [HTTP_QUERY_IF_MODIFIED_SINCE] : Retrieves the contents of the If-Modified-Since header.
    procedure set_hdqIfModifiedSince(p:string);                // [HTTP_QUERY_IF_MODIFIED_SINCE] : Sets the contents of the If-Modified-Since header.
    function  get_hdqIfNoneMatch:string;                       // [HTTP_QUERY_IF_NONE_MATCH] : Retrieves the contents of the If-None-Match request-header field.
    procedure set_hdqIfNoneMatch(p:string);                    // [HTTP_QUERY_IF_NONE_MATCH] : Sets the contents of the If-None-Match request-header field.
    function  get_hdqIfRange:string;                           // [HTTP_QUERY_IF_RANGE] : Retrieves the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
    procedure set_hdqIfRange(p:string);                        // [HTTP_QUERY_IF_RANGE] : Sets the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
    function  get_hdqIfUnmodifiedSince:string;                 // [HTTP_QUERY_IF_UNMODIFIED_SINCE] : Retrieves the contents of the If-Unmodified-Since request-header field.
    procedure set_hdqIfUnmodifiedSince(p:string);              // [HTTP_QUERY_IF_UNMODIFIED_SINCE] : Sets the contents of the If-Unmodified-Since request-header field.
    function  get_hdqMaxForwards:string;                       // [HTTP_QUERY_MAX_FORWARDS] : Retrieves the number of proxies or gateways that can forward the request to the next inbound server.
    procedure set_hdqMaxForwards(p:string);                    // [HTTP_QUERY_MAX_FORWARDS] : Sets the number of proxies or gateways that can forward the request to the next inbound server.
    function  get_hdqPragma:string;                            // [HTTP_QUERY_PRAGMA] : Receives the implementation-specific directives that might apply to any recipient along the request/response chain.
    procedure set_hdqPragma(p:string);                         // [HTTP_QUERY_PRAGMA] : Sets the implementation-specific directives that might apply to any recipient along the request/response chain.
    function  get_hdqProxyAuthorization:string;                // [HTTP_QUERY_PROXY_AUTHORIZATION] : Retrieves the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
    procedure set_hdqProxyAuthorization(p:string);             // [HTTP_QUERY_PROXY_AUTHORIZATION] : Sets the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
    function  get_hdqProxyConnection:string;                   // [HTTP_QUERY_PROXY_CONNECTION] : Retrieves the Proxy-Connection header.
    procedure set_hdqProxyConnection(p:string);                // [HTTP_QUERY_PROXY_CONNECTION] : Sets the Proxy-Connection header.
    function  get_hdqRange:string;                             // [HTTP_QUERY_RANGE] : Retrieves the byte range of an entity.
    procedure set_hdqRange(p:string);                          // [HTTP_QUERY_RANGE] : Sets the byte range of an entity.
    function  get_hdqRawHeaders:TStrings;                      // [HTTP_QUERY_RAW_HEADERS_CRLF] : Receives all the headers associated by the request. Each header is separated by a carriage return/line feed (CR/LF) sequence.
    function  get_hdqRequestMethod:string;                     // [HTTP_QUERY_REQUEST_METHOD] : Receives the HTTP verb that is being used in the request, typically GET or POST.
    function  get_hdqRetryAfter:string;                        // [HTTP_QUERY_RETRY_AFTER] : Retrieves the amount of time the service is expected to be unavailable.
    procedure set_hdqRetryAfter(p:string);                     // [HTTP_QUERY_RETRY_AFTER] : Sets the amount of time the service is expected to be unavailable.
    function  get_hdqCookie:string;                         // [HTTP_QUERY_SET_COOKIE] : Receives the value of the cookie set for the request.
    procedure set_hdqCookie(p:string);                      // [HTTP_QUERY_SET_COOKIE] : Sets the value of the cookie set for the request.
    function  get_hdqTransferEncoding:string;                  // [HTTP_QUERY_TRANSFER_ENCODING] : Retrieves the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
    procedure set_hdqTransferEncoding(p:string);               // [HTTP_QUERY_TRANSFER_ENCODING] : Sets the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
    function  get_hdqUnlessModifiedSince:string;               // [HTTP_QUERY_UNLESS_MODIFIED_SINCE] : Retrieves the Unless-Modified-Since header.
    procedure set_hdqUnlessModifiedSince(p:string);            // [HTTP_QUERY_UNLESS_MODIFIED_SINCE] : Sets the Unless-Modified-Since header.
    function  get_hdqUserAgent:string;                         // [HTTP_QUERY_USER_AGENT] : Retrieves information about the user agent that made the request.
    procedure set_hdqUserAgent(p:string);                      // [HTTP_QUERY_USER_AGENT] : Sets information about the user agent that made the request.
    function  get_hdqVia:string;                               // [HTTP_QUERY_VIA] : Retrieves the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
    procedure set_hdqVia(p:string);                            // [HTTP_QUERY_VIA] : Sets the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.


    function  get_hdrAge:string;                               // [HTTP_QUERY_AGE] : Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
    function  get_hdrAllow:string;                             // [HTTP_QUERY_ALLOW] : Receives the HTTP verbs supported by the server.
    function  get_hdrCacheControl:string;                      // [HTTP_QUERY_CACHE_CONTROL] : Retrieves the cache control directives.
    function  get_hdrConnection:string;                        // [HTTP_QUERY_CONNECTION]  : Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
    function  get_hdrContentBase:string;                       // [HTTP_QUERY_CONTENT_BASE] : Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
    function  get_hdrContentDesc:string;                       // [HTTP_QUERY_CONTENT_DESCRIPTION] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrContentDisp:string;                       // [HTTP_QUERY_CONTENT_DISPOSITION] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrContentEncoding:string;                   // [HTTP_QUERY_CONTENT_ENCODING] : Retrieves any additional content codings that have been applied to the entire resource.
    function  get_hdrContentID:string;                         // [HTTP_QUERY_CONTENT_ID] : Retrieves the content identification.
    function  get_hdrContentLang:string;                       // [HTTP_QUERY_CONTENT_LANGUAGE] : Retrieves the language that the content is in.
    function  get_hdrContentLength:dword;                     // [HTTP_QUERY_CONTENT_LENGTH] : Retrieves the size of the resource, in bytes.
    function  get_hdrContentLocation:string;                   // [HTTP_QUERY_CONTENT_LOCATION] : Retrieves the resource location for the entity enclosed in the message.
    function  get_hdrContentMD5:string;                        // [HTTP_QUERY_CONTENT_MD5] : Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
    function  get_hdrContentRange:string;                      // [HTTP_QUERY_CONTENT_RANGE] : Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
    function  get_hdrContTransEncoding:string;                 // [HTTP_QUERY_CONTENT_TRANSFER_ENCODING] : Receives the additional content coding that has been applied to the resource.
    function  get_hdrContentType:string;                       // [HTTP_QUERY_CONTENT_TYPE] : Receives the content type of the resource (such as text/html).
    function  get_hdrCookies:TStrings;                         // [HTTP_QUERY_COOKIE] : Retrieves any cookies associated with the request.
    function  get_hdrCost:string;                              // [HTTP_QUERY_COST] : No longer supported.
    function  get_hdrDate:string;                              // [HTTP_QUERY_DATE]: Receives the date and time at which the message was originated.
    function  get_hdrDerivedFrom:string;                       // [HTTP_QUERY_DERIVED_FROM] : No longer supported.
    function  get_hdrEchoHeaders:TStrings;                     // [HTTP_QUERY_ECHO_HEADERS_CRLF] : Not currently implemented.
    function  get_hdrEchoReply:string;                         // [HTTP_QUERY_ECHO_REPLY] : Not currently implemented.
    function  get_hdrEchoRequest:string;                       // [HTTP_QUERY_ECHO_REQUEST] : Not currently implemented.
    function  get_hdrETag:string;                              // [HTTP_QUERY_ETAG] : Retrieves the entity tag for the associated entity.
    function  get_hdrExpires:string;                           // [HTTP_QUERY_EXPIRES] : Receives the date and time after which the resource should be considered outdated.
    function  get_hdrForwarded:string;                         // [HTTP_QUERY_FORWARDED] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrFrom:string;                              // [HTTP_QUERY_FROM] : Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
    function  get_hdrHost:string;                              // [HTTP_QUERY_HOST] : Retrieves the Internet host and port number of the resource being requested.
    function  get_hdrLastModified:string;                      // [HTTP_QUERY_LAST_MODIFIED] : Receives the date and time at which the server believes the resource was last modified.
    function  get_hdrLink:string;                              // [HTTP_QUERY_LINK] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrLocation:string;                          // [HTTP_QUERY_LOCATION] : Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
    function  get_hdrMessageId:string;                         // [HTTP_QUERY_MESSAGE_ID] : No longer supported.
    function  get_hdrMimeVersion:string;                       // [HTTP_QUERY_MIME_VERSION] : Receives the version of the MIME protocol that was used to construct the message.
    function  get_hdrOrigURI:string;                           // [HTTP_QUERY_ORIG_URI] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrProxyAuthenticate:string;                 // [HTTP_QUERY_PROXY_AUTHENTICATE] : Retrieves the authentication scheme and realm returned by the proxy.
    function  get_hdrPublic:string;                            // [HTTP_QUERY_PUBLIC] : Receives methods available at this server.
    function  get_hdrRawHeaders:TStrings;                      // [HTTP_QUERY_RAW_HEADERS_CRLF] : Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
    function  get_hdrReferrer:string;                          // [HTTP_QUERY_REFERER] : Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
    function  get_hdrRefresh:string;                           // [HTTP_QUERY_REFRESH] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrServerDesc:string;                        // [HTTP_QUERY_SERVER] : Retrieves information about the software used by the origin server to handle the request.
    function  get_hdrStatusCode:dword;                        // [HTTP_QUERY_STATUS_CODE] : Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
    function  get_hdrStatusText:string;                        // [HTTP_QUERY_STATUS_TEXT] : Receives any additional text returned by the server on the response line.
    function  get_hdrTitle:string;                             // [HTTP_QUERY_TITLE] : Obsolete. Maintained for legacy application compatibility only.
    function  get_hdrUpgrade:string;                           // [HTTP_QUERY_UPGRADE] : Retrieves the additional communication protocols that are supported by the server.
    function  get_hdrURI:string;                               // [HTTP_QUERY_URI] : Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.
    function  get_hdrVary:string;                              // [HTTP_QUERY_VARY] : Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
    function  get_hdrVersion:string;                           // [HTTP_QUERY_VERSION] : Receives the last response code returned by the server.
    function  get_hdrWarning:string;                           // [HTTP_QUERY_WARNING] : Retrieves additional information about the status of a response that might not be reflected by the response status code.
    function  get_hdrWWW_Authenticate:string;                  // [HTTP_QUERY_WWW_AUTHENTICATE] : Retrieves the authentication scheme and realm returned by the server.

    procedure Loaded;override;
  public
    property UploadData    :pchar read fUploadData write fUploadData;
    property UploadDataSize:dword read fUploadDataSize write fUploadDataSize;

    property HttpContext:pointer read getHttpContext write setHttpContext;             //  A Pointer to a value that contains the application-defined value that associates this operation with any application data.
    //property hHttpRequest :pointer read getHttpHandle;
    property hConnection  :pointer read gethConnection;
    procedure OpenRequest;override;
    procedure SendRequest(ReceiveStream:TStream);override;
    procedure CloseRequest;override;
    {
    procedure Connect;override;
    procedure Disconnect;override;

    procedure Open(ReceiveStream:TStream);                   // Does all required tasks to access web resources in one way.
    }
    constructor Create(aOwner:TComponent);override;
    destructor  Destroy;override;
  published
    property Method     : TInternetHttpMethods read getMethod write setMethod;          // that contains the HTTP verb to use in the request. Default value is "hmGET".
    property Version    : HTTP_VERSION_INFO read getVersion write setVersion;           // Only [maj,min] 1.0 or 1.1 values supported as HTTP Protocol Verion. Default value is 1.1.
    property Referrer   : string read getReferrer write setReferrer;                    // a string that specifies the URL of the document from which the URL in the request (ObjectName) was obtained. If this parameter is NULL, no "referrer" is specified
    property AcceptTypes: TStrings read getAcceptTypes write setAcceptTypes;            // array of strings indicating media types accepted by the client. If this parameter is NULL, no types are accepted by the client. Servers generally interpret a lack of accept types to indicate that the client accepts only documents of type "text/*" (that is, only text documents—no pictures or other binary files). For a list of valid media types, see "Media Types" at ftp://ftp.isi.edu/in-notes/iana/assignments/media-types/media-types .
    //property PostData   : string read getPostData write setPostData;                    // A String buffer that contains data to send to server if method is POST or PUT
    property PostEnctype: string read fPostEnctype write fPostEnctype;

    property Connection : TCustomInternetConnection read getConnection write setConnection;
    property ObjectName : string read getObjectName write setObjectName;          // a string that contains the name of the target object of the specified HTTP verb. This is generally a file name, an executable module, or a search specifier.
    { Option Properties(affects FLAGS property)   }
    property opCacheIfNetFail:boolean                                                   // [ API FLAG: NET_FLAG_CACHE_IF_NET_FAIL             ]
         read get_opCacheIfNetFail write set_opCacheIfNetFail;                          // Returns the resource from the cache if the network request for the resource fails due to an ERROR_INTERNET_CONNECTION_RESET (the connection with the server has been reset) or ERROR_INTERNET_CANNOT_CONNECT (the attempt to connect to the server failed).
    property opHyperlink:boolean                                                        // [ API FLAG: INTERNET_FLAG_HYPERLINK                ]
         read get_opHyperlink write set_opHyperlink;                                    // Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
    property opIgnoreCertCNInvalid:boolean                                              // [ API FLAG: INTERNET_FLAG_IGNORE_CERT_CN_INVALID   ]
         read get_opIgnoreCertCNInvalid write set_opIgnoreCertCNInvalid;                // Disables Microsoft® Win32® Internet function checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. Win32 Internet functions use a simple check against certificates by comparing for matching host names and simple wildcarding rules.
    property opIgnoreCertDateInvalid:boolean                                            // [ API FLAG: INTERNET_FLAG_IGNORE_CERT_DATE_INVALID ]
         read get_opIgnoreCertDateInvalid write set_opIgnoreCertDateInvalid;            // Disables Win32 Internet function checking of SSL/PCT-based certificates for proper validity dates.
    property opIgnoreRedirectToHTTP:boolean                                             // [ API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  ]
         read get_opIgnoreRedirectToHTTP write set_opIgnoreRedirectToHTTP;              // Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTPS to HTTP URLs.
    property opIgnoreRedirectToHTTPS:boolean                                            // [ API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS ]
         read get_opIgnoreRedirectToHTTPS write set_opIgnoreRedirectToHTTPS;            // Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTP to HTTPS URLs.
    property opKeepConnection: boolean                                                  // [ API FLAG: INTERNET_FLAG_KEEP_CONNECTION          ]
         read get_opKeepConnection write set_opKeepConnection;                          // Uses keep-alive semantics, if available, for the connection. This flag is required for Microsoft Network (MSN), NT LAN Manager (NTLM), and other types of authentication
    property opNeedFile:boolean                                                         // [ API FLAG: INTERNET_FLAG_NEED_FILE                ]
         read get_opNeedFile write set_opNeedFile;                                      // Causes a temporary file to be created if the file cannot be cached. For ex: SSL or PCT pages
    property opNoAutoAuth:boolean                                                       // [ API FLAG: INTERNET_FLAG_NO_AUTH                  ]
         read get_opNoAutoAuth write set_opNoAutoAuth;                                  // Does not attempt authentication automatically.
    property opNoAutoRedirect:boolean                                                   // [ API FLAG: INTERNET_FLAG_NO_AUTO_REDIRECT         ]
         read get_opNoAutoRedirect write set_opNoAutoRedirect;                          // Does not automatically handle redirection in HttpSendRequest.
    property opNoCacheWrite:boolean                                                     // [ API FLAG: INTERNET_FLAG_NO_CACHE_WRITE           ]
         read get_opNoCacheWrite write set_opNoCacheWrite;                              // Does not add the returned entity to the cache.
    property opCookieHandling:THTTPCookieHandlingTypes                                  // [ API FLAG: INTERNET_FLAG_NO_COOKIES               ]
         read get_opCookieHandling write set_opCookieHandling;                          // Determines what kind of cookie handling will done.
    property opDisableCookieDialogbox:boolean                                           // [ API FLAG: INTERNET_FLAG_NO_UI                    ]
         read get_opDisableCookieDialogbox write set_opDisableCookieDialogbox;          // Disables the cookie dialog box.
    property opForceProxyToReload:boolean                                               // [ API FLAG: INTERNET_FLAG_PRAGMA_NOCACHE           ]
         read get_opForceProxyToReload write set_opForceProxyToReload;                  // Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
    property opForceReload:boolean                                                      // [ API FLAG: INTERNET_FLAG_RELOAD                   ]
         read get_opForceReload write set_opForceReload;                                // Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
    property opResynchronize:boolean                                                    // [ API FLAG: INTERNET_FLAG_RESYNCHRONIZE            ]
          read get_opResynchronize write set_opResynchronize;                           // Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded.
    property opSecure:boolean                                                           // [ API FLAG: INTERNET_FLAG_SECURE                   ]
           read get_opSecure write set_opSecure;                                        // Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests.

    //HTTP Request Header Fields [RFC 2616]
    property hdqAcceptTypes:string read get_hdqAcceptTypes write set_hdqAcceptTypes;          // Retrieves or Sets the acceptable media types for the response.
    property hdqAcceptCharSet:string read get_hdqAcceptCharSet write set_hdqAcceptCharSet;    // Retrieves or Sets the acceptable character sets for the response.
    property hdqAcceptEncoding:string read get_hdqAcceptEncoding write set_hdqAcceptEncoding; // Retrieves or Sets the acceptable content-coding values for the response.
    property hdqAcceptLanguage:string read get_hdqAcceptLanguage write set_hdqAcceptLanguage; // Retrieves or Sets the acceptable natural languages for the response.
    property hdqAcceptRanges:string read get_hdqAcceptRanges write set_hdqAcceptRanges;       // Retrieves or Sets the types of range requests that are accepted for a resource.
    property hdqAuthorization:string read get_hdqAuthorization write set_hdqAuthorization;    // Retrieves or Sets the authorization credentials used for a request.
    property hdqExpect:string read get_hdqExpect write set_hdqExpect;                         // Retrieves or Sets the Expect header, which indicates whether the client application should expect 100 series responses.
    property hdqIfMatch:string read get_hdqIfMatch write set_hdqIfMatch;                      // Retrieves or Sets the contents of the If-Match request-header field.
    property hdqIfModifiedSince:string read get_hdqIfModifiedSince write set_hdqIfModifiedSince;  // Retrieves or Sets the contents of the If-Modified-Since header.
    property hdqIfNoneMatch:string read get_hdqIfNoneMatch write set_hdqIfNoneMatch;         // Retrieves or sets the contents of the If-None-Match request-header field.
    property hdqIfRange:string read get_hdqIfRange write set_hdqIfRange;                     // Retrieves or sets the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
    property hdqIfUnmodifiedSince:string read get_hdqIfUnmodifiedSince write set_hdqIfUnmodifiedSince;   // Retrieves or sets the contents of the If-Unmodified-Since request-header field.
    property hdqMaxForwards:string read get_hdqMaxForwards write set_hdqMaxForwards;         // Retrieves or sets the number of proxies or gateways that can forward the request to the next inbound server.
    property hdqPragma:string read get_hdqPragma write set_hdqPragma;                        // Receives or sets the implementation-specific directives that might apply to any recipient along the request/response chain.
    property hdqProxyAuthorization:string read get_hdqProxyAuthorization write set_hdqProxyAuthorization; // Retrieves or sets the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
    property hdqProxyConnection:string read get_hdqProxyConnection write set_hdqProxyConnection;          // Retrieves or sets the Proxy-Connection header.
    property hdqRange:string read get_hdqRange write set_hdqRange;                           // Retrieves or sets the byte range of an entity.
    property hdqRawHeaders:TStrings read get_hdqRawHeaders;                                  // Receives all the headers that are associated with request. Each header is separated by a carriage return/line feed (CR/LF) sequence.
    property hdqRequestMethod:string read get_hdqRequestMethod;                              // Receives the HTTP verb that is being used in the request, typically GET or POST.
    property hdqRetryAfter:string read get_hdqRetryAfter write set_hdqRetryAfter;            // Retrieves or sets the amount of time the service is expected to be unavailable.
    property hdqCookie:string read get_hdqCookie write set_hdqCookie;                        // Sends or Receives the value of the cookie set for the request.
    property hdqTransferEncoding:string read get_hdqTransferEncoding write set_hdqTransferEncoding;          // Retrieves or sets the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
    property hdqUnlessModifiedSince:string read get_hdqUnlessModifiedSince write set_hdqUnlessModifiedSince; // Retrieves or sets the Unless-Modified-Since header.
    property hdqUserAgent:string read get_hdqUserAgent write set_hdqUserAgent;               // Retrieves or sets information about the user agent that made the request.
    property hdqVia:string read get_hdqVia write set_hdqVia;                                 // Retrieves or sets the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.

    //HTTP Response Header Fields [RFC 2616]
    property hdrAge:string read get_hdrAge;                                                   // Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
    property hdrAllow:string read get_hdrAllow;                                               // Receives the HTTP verbs supported by the server.
    property hdrCacheControl:string read get_hdrCacheControl;                                 // Retrieves the cache control directives.
    property hdrConnection:string read get_hdrConnection;                                     // Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
    property hdrContentBase:string read get_hdrContentBase;                                   // Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
    property hdrContentDesc:string read get_hdrContentDesc;                                   // Obsolete. Maintained for legacy application compatibility only.
    property hdrContentDisp:string read get_hdrContentDisp;                                   // Obsolete. Maintained for legacy application compatibility only.
    property hdrContentEncoding:string read get_hdrContentEncoding;                           // Retrieves any additional content codings that have been applied to the entire resource.
    property hdrContentID:string read get_hdrContentID;                                       // Retrieves the content identification.
    property hdrContentLang:string read get_hdrContentLang;                                   // Retrieves the language that the content is in.
    property hdrContentLength:dword read get_hdrContentLength;                               // Retrieves the size of the resource, in bytes.
    property hdrContentLocation:string read get_hdrContentLocation;                           // Retrieves the resource location for the entity enclosed in the message.
    property hdrContentMD5:string read get_hdrContentMD5;                                     // Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
    property hdrContentRange:string read get_hdrContentRange;                                 // Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
    property hdrContTransEncoding:string read get_hdrContTransEncoding;                       // Receives the additional content coding that has been applied to the resource.
    property hdrContentType:string read get_hdrContentType;                                   // Receives the content type of the resource (such as text/html).
    property hdrCookies:TStrings read get_hdrCookies;                                             // Retrieves any cookies associated with the request.
    property hdrCost:string read get_hdrCost;                                                 // No longer supported.
    property hdrDate:string read get_hdrDate;                                                 // Receives the date and time at which the message was originated.
    property hdrDerivedFrom:string read get_hdrDerivedFrom;                                   // No longer supported.
    property hdrEchoHeaders:TStrings read get_hdrEchoHeaders;                                 // Not currently implemented.
    property hdrEchoReply:string read get_hdrEchoReply;                                       // Not currently implemented.
    property hdrEchoRequest:string read get_hdrEchoRequest;                                   // Not currently implemented.
    property hdrETag:string read get_hdrETag;                                                 // Retrieves the entity tag for the associated entity.
    property hdrExpires:string read get_hdrExpires;                                           // Receives the date and time after which the resource should be considered outdated.
    property hdrForwarded:string read get_hdrForwarded;                                       // Obsolete. Maintained for legacy application compatibility only.
    property hdrFrom:string read get_hdrFrom;                                                 // Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
    property hdrHost:string read get_hdrHost;                                                 // Retrieves the Internet host and port number of the resource being requested.
    property hdrLastModified:string read get_hdrLastModified;                                // Receives the date and time at which the server believes the resource was last modified.
    property hdrLink:string read get_hdrLink;                                                // Obsolete. Maintained for legacy application compatibility only.
    property hdrLocation:string read get_hdrLocation;                                        // Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
    property hdrMessageId:string read get_hdrMessageId;                                      // No longer supported.
    property hdrMimeVersion:string read get_hdrMimeVersion;                                  // Receives the version of the MIME protocol that was used to construct the message.
    property hdrOrigURI:string read get_hdrOrigURI;                                          // Obsolete. Maintained for legacy application compatibility only.
    property hdrProxyAuthenticate:string read get_hdrProxyAuthenticate;                      // Retrieves the authentication scheme and realm returned by the proxy.
    property hdrPublic:string read get_hdrPublic;                                            // Receives methods available at this server.
    property hdrRawHeaders:TStrings read get_hdrRawHeaders;                                  // Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
    property hdrReferrer:string read get_hdrReferrer;                                        // Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
    property hdrRefresh:string read get_hdrRefresh;                                          // Obsolete. Maintained for legacy application compatibility only.
    property hdrServerDesc:string read get_hdrServerDesc;                                    // Retrieves information about the software used by the origin server to handle the request.
    property hdrStatusCode:dword read get_hdrStatusCode;                                    // Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
    property hdrStatusText:string read get_hdrStatusText;                                    // Receives any additional text returned by the server on the response line.
    property hdrTitle:string read get_hdrTitle;                                              // Obsolete. Maintained for legacy application compatibility only.
    property hdrUpgrade:string read get_hdrUpgrade;                                          // Retrieves the additional communication protocols that are supported by the server.
    property hdrURI:string read get_hdrURI;                                                  // Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.
    property hdrVary:string read get_hdrVary;                                                // Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
    property hdrVersion:string read get_hdrVersion;                                          // Receives the last response code returned by the server.
    property hdrWarning:string read get_hdrWarning;                                          // Retrieves additional information about the status of a response that might not be reflected by the response status code.
    property hdrWWW_Authenticate:string read get_hdrWWW_Authenticate;                        // Retrieves the authentication scheme and realm returned by the server.
  end;

  TFTPConnection = class (TCustomInternetConnection)
  private
  protected
  public
  published
  end;

  TGopherConnection=class (TCustomInternetConnection)
  private
  protected
  public
  published
  end;

  TInternetFile= class (TFileStream)
  private
  protected
  public
  published
  end;

  THTTPFile=class (TInternetFile)
  private
  protected
  public
  published
  end;

  TFTPFile=class (TInternetFile)
  private
  protected
  public
  published
  end;

  TGopherFile=class (TInternetFile)
  private
  protected
  public
  published
  end;

  TFindFile = class (TObject)
  private
  protected
  public
  published
  end;

  TFTPFileFind =class (TFindFile)
  private
  protected
  public
  published
  end;

  TGopherFileFind = class (TFindFile)
  private
  protected
  public
  published
  end;


  THTTPCookie = class(TCollectionItem)
  private
    FName: string;
    FValue: string;
    FPath: string;
    FExpires: TDateTime;
    FSecure: Boolean;
  protected
    function GetHeaderValue: string;
    function GetDomain:string;
    procedure SetName(aName:string);
    function  get_isSessionCookie:boolean;
  public
    constructor Create(Collection: TCollection); override;
    procedure AssignTo(Dest: TPersistent); override;
    property Name: string read FName write SetName;
    property Value: string read FValue write FValue;
    property Domain: string read GetDomain;
    property Path: string read FPath write FPath;
    property Expires: TDateTime read FExpires write FExpires;
    property Secure: Boolean read FSecure write FSecure;
    property HeaderValue: string read GetHeaderValue;
    property isSessionCookie:boolean read get_isSessionCookie;
  end;

  THTTPCookies = class (TCollection)
  private
    fDomain  : string;
    fBasePath: string;
    fOwner   : TCustomInternetConnection;
  protected
    function  GetCookie(Index: Integer): THTTPCookie;
    procedure SetCookie(Index: Integer; Cookie: THTTPCookie);
    function  GetCookieByName(Index:string): THTTPCookie;
    procedure SetCookieByName(Index:string; p:THTTPCookie);
    procedure LoadFromDisk;
    procedure SaveToDisk;
    procedure ExtractCookieFields(CookieStr:string;Strings: TStrings);

    function  GetFileName:string;
    function  GetCookieFilesBasePath:string;
    function  getCurrUser:string;
    function  getDomain:string;
  public
    property  ItemByIndex[Index: Integer]: THTTPCookie read GetCookie write SetCookie; default;
    property  ItemByName [index: string]:  THTTPCookie read GetCookieByName write SetCookieByNAme;
    procedure SetDomain(aDomain:string);//write buffer to disk;read new values
    function  Add: THTTPCookie;
    function  FindCookie(CookieName:string):THTTPCookie;
    Procedure PlaceCookie(CookieHeader:string);
    Function  GetCookieHeader:string;
    constructor Create(aOwner:TCustomInternetConnection);
    destructor  destroy;override;
  published
    property  BasePath:string read fBasePath write fBasePath;
    property Domain:string read getDomain;
    property CurrentUser:string read getCurrUser;
  end;

  Procedure Register;

  procedure RaiseLastAPIError;overload;
  procedure RaiseLastAPIError(LastError: dword);overload;

  {  **** Cracks a URL into its component parts.                                                                          }
  {  see http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcrackurl.asp for more details  }
  function InternalInternetCrackUrl(
                            Url: string;                        // string that contains the canonical URL to crack
                            options:TInternetURLCrackOptions;   // icoDECODE: Converts encoded characters back to their normal form.
                                                                // icoESCAPE Converts all escape sequences (%xx) to their corresponding characters
                            var UrlComponents: TURL_Components  // TURLCOMPONENTS structure that receives the URL components
                            ): boolean;                         // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                              //   To get extended error information, "call GetLastError"

  { **** GLOBAL VARIABLES ****}
var
  //Callbacks: TObjectList = nil;
  CbBrokerbusy :boolean = false;
  iSession: TInternetSession=nil;
implementation

{ **********************************************************************************************************************}
{ *********************************************** IMPLEMENTATION SECTION ***********************************************}
{ **********************************************************************************************************************}
Procedure Register;
begin
  RegisterComponents('Internet',[TInternetSession,TInternetConnection,TInternetHTTPRequest]);
end;


{API PROTOTYPES}
const
  winetdll = 'wininet.dll';

function InternetTimeToSystemTime;      external winetdll name 'InternetTimeToSystemTime';


{CALLBACK BROKER}

{*************************** IMPORTANT FOR MULTI THREADED APPLICATIONS ******************************************}
{ On Progress events based on this broker MUST return as soon as possible after they called to prevent conflicts }

var
{
  fhInet:HINTERNET;
  fdwContext:DWORD;fdwInternetStatus:DWORD;
  flpvStatusInformation:pointer;
  fdwStatusInformationLength:DWORD;
}
  CallBackRec:PWM_CALLBACK_REC;
procedure InternetCallBackDispatcher(hInet:HINTERNET;dwContext:DWORD;dwInternetStatus:DWORD;lpvStatusInformation:pointer;dwStatusInformationLength:DWORD);stdcall;
var
  //i:integer;
  //pCallBackContext:PInternetCallbackContext;
  cnt:dword;

begin
  //for debug
  //exit;

  cnt:=0;
  //wait until the broker became available [for multihreading]
  while (CbBrokerbusy and (cnt<50))do
  begin
    sleep(1);
    inc(cnt);
    //if cnt=999 then
    //  cnt:=1000;
  end;
  CbBrokerbusy:=true; //lock broker
  try
    //cache func paramaters to prevent multithreading conflicts
    CallBackRec:=new(PWM_CALLBACK_REC);
    CallBackRec.hInet:=hInet;
    CallBackRec.dwContext:=dwContext;
    CallBackRec.dwInternetStatus:=dwInternetStatus;
    CallBackRec.lpvStatusInformation:=lpvStatusInformation;
    CallBackRec.dwStatusInformationLength:=dwStatusInformationLength;
    if GetCurrentThreadId<>MainThreadID then
      SendMessage(HWND(dwContext),WM_INTERNET_CALLBACK,integer(CallBackRec),0)
    else
      PostMessage(HWND(dwContext),WM_INTERNET_CALLBACK,integer(CallBackRec),0);
    (*
    try
      pCallBackContext:=PInternetCallbackContext(dwContext);
      i:=pCallBackContext.CallbackID;
      if (i>-1) and (i<Callbacks.Count) then
      if assigned(TInternetCallbackHolder(Callbacks[i]).CallBackProc) then
            TInternetCallbackHolder(Callbacks[i]).CallBackProc(fhInet, fdwContext,fdwInternetStatus,flpvStatusInformation,fdwStatusInformationLength);
    except on e: exception do
    end;
    *)
  finally
    CbBrokerbusy:=false;  //unlock borker in any case
  end;
end;
{TInternetCallbackHolder}
procedure TInternetCallbackHolder.doOnCallback(hInet:HINTERNET;dwContext:DWORD;dwInternetStatus:DWORD;lpvStatusInformation:pointer;dwStatusInformationLength:DWORD);
begin
  try
    if assigned(fCallbackProc) then
      fCallbackProc(hInet,dwContext,dwInternetStatus,lpvStatusInformation,dwStatusInformationLength);
  except on e:exception do
  end;
end;

function TranslateAPIErrorCode(ErrorCode:dword):string;
begin
  Case ErrorCode of
    ERROR_FTP_DROPPED                    : result:= sERROR_FTP_DROPPED;
    ERROR_FTP_NO_PASSIVE_MODE            : result:= sERROR_FTP_NO_PASSIVE_MODE;
    ERROR_FTP_TRANSFER_IN_PROGRESS       : result:= sERROR_FTP_TRANSFER_IN_PROGRESS;
    ERROR_GOPHER_ATTRIBUTE_NOT_FOUND     : result:= sERROR_GOPHER_ATTRIBUTE_NOT_FOUND;
    ERROR_GOPHER_DATA_ERROR              : result:= sERROR_GOPHER_DATA_ERROR;
    ERROR_GOPHER_END_OF_DATA             : result:= sERROR_GOPHER_END_OF_DATA;
    ERROR_GOPHER_INCORRECT_LOCATOR_TYPE  : result:= sERROR_GOPHER_INCORRECT_LOCATOR_TYPE;
    ERROR_GOPHER_INVALID_LOCATOR         : result:= sERROR_GOPHER_INVALID_LOCATOR;
    ERROR_GOPHER_NOT_FILE                : result:= sERROR_GOPHER_NOT_FILE;
    ERROR_GOPHER_NOT_GOPHER_PLUS         : result:= sERROR_GOPHER_NOT_GOPHER_PLUS;
    ERROR_GOPHER_PROTOCOL_ERROR          : result:= sERROR_GOPHER_PROTOCOL_ERROR;
    ERROR_GOPHER_UNKNOWN_LOCATOR         : result:= sERROR_GOPHER_UNKNOWN_LOCATOR;
    ERROR_HTTP_COOKIE_DECLINED           : result:= sERROR_HTTP_COOKIE_DECLINED;
    ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION : result:= sERROR_HTTP_COOKIE_NEEDS_CONFIRMATION;
    ERROR_HTTP_DOWNLEVEL_SERVER          : result:= sERROR_HTTP_DOWNLEVEL_SERVER;
    ERROR_HTTP_HEADER_ALREADY_EXISTS     : result:= sERROR_HTTP_HEADER_ALREADY_EXISTS;
    ERROR_HTTP_HEADER_NOT_FOUND          : result:= sERROR_HTTP_HEADER_NOT_FOUND;
    ERROR_HTTP_INVALID_HEADER            : result:= sERROR_HTTP_INVALID_HEADER;
    ERROR_HTTP_INVALID_QUERY_REQUEST     : result:= sERROR_HTTP_INVALID_QUERY_REQUEST;
    ERROR_HTTP_INVALID_SERVER_RESPONSE   : result:= sERROR_HTTP_INVALID_SERVER_RESPONSE;
    ERROR_HTTP_NOT_REDIRECTED            : result:= sERROR_HTTP_NOT_REDIRECTED;
    ERROR_HTTP_REDIRECT_FAILED           : result:= sERROR_HTTP_REDIRECT_FAILED;
    ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION : result:= sERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION;
    ERROR_INTERNET_ASYNC_THREAD_FAILED     : result:= sERROR_INTERNET_ASYNC_THREAD_FAILED;
    ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT   : result:= sERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT;
    ERROR_INTERNET_BAD_OPTION_LENGTH       : result:= sERROR_INTERNET_BAD_OPTION_LENGTH;
    ERROR_INTERNET_BAD_REGISTRY_PARAMETER  : result:= sERROR_INTERNET_BAD_REGISTRY_PARAMETER;
    ERROR_INTERNET_CANNOT_CONNECT          : result:= sERROR_INTERNET_CANNOT_CONNECT;
    ERROR_INTERNET_CHG_POST_IS_NON_SECURE  : result:= sERROR_INTERNET_CHG_POST_IS_NON_SECURE;
    ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED : result:= sERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED;
    ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP   : result:= sERROR_INTERNET_CLIENT_AUTH_NOT_SETUP;
    ERROR_INTERNET_CONNECTION_ABORTED      : result:= sERROR_INTERNET_CONNECTION_ABORTED;
    ERROR_INTERNET_CONNECTION_RESET        : result:= sERROR_INTERNET_CONNECTION_RESET;
    ERROR_INTERNET_DIALOG_PENDING          : result:= sERROR_INTERNET_DIALOG_PENDING;
    ERROR_INTERNET_DISCONNECTED            : result:= sERROR_INTERNET_DISCONNECTED;
    ERROR_INTERNET_EXTENDED_ERROR          : result:= sERROR_INTERNET_EXTENDED_ERROR;
    ERROR_INTERNET_FAILED_DUETOSECURITYCHECK : result:= sERROR_INTERNET_FAILED_DUETOSECURITYCHECK;
    ERROR_INTERNET_FORCE_RETRY               : result:= sERROR_INTERNET_FORCE_RETRY;
    ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED     : result:= sERROR_INTERNET_FORTEZZA_LOGIN_NEEDED;
    ERROR_INTERNET_HANDLE_EXISTS             : result:= sERROR_INTERNET_HANDLE_EXISTS;
    ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR    : result:= sERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR;
    ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR   : result:= sERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR;
    ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR    : result:= sERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR;
    ERROR_INTERNET_INCORRECT_FORMAT          : result:= sERROR_INTERNET_INCORRECT_FORMAT;
    ERROR_INTERNET_INCORRECT_HANDLE_STATE    : result:= sERROR_INTERNET_INCORRECT_HANDLE_STATE;
    ERROR_INTERNET_INCORRECT_HANDLE_TYPE     : result:= sERROR_INTERNET_INCORRECT_HANDLE_TYPE;
    ERROR_INTERNET_INCORRECT_PASSWORD        : result:= sERROR_INTERNET_INCORRECT_PASSWORD;
    ERROR_INTERNET_INCORRECT_USER_NAME       : result:= sERROR_INTERNET_INCORRECT_USER_NAME;
    ERROR_INTERNET_INSERT_CDROM              : result:= sERROR_INTERNET_INSERT_CDROM;
    ERROR_INTERNET_INTERNAL_ERROR            : result:= sERROR_INTERNET_INTERNAL_ERROR;
    ERROR_INTERNET_INVALID_CA                : result:= sERROR_INTERNET_INVALID_CA;
    ERROR_INTERNET_INVALID_OPERATION         : result:= sERROR_INTERNET_INVALID_OPERATION;
    ERROR_INTERNET_INVALID_OPTION            : result:= sERROR_INTERNET_INVALID_OPTION;
    ERROR_INTERNET_INVALID_PROXY_REQUEST     : result:= sERROR_INTERNET_INVALID_PROXY_REQUEST;
    ERROR_INTERNET_INVALID_URL               : result:= sERROR_INTERNET_INVALID_URL;
    ERROR_INTERNET_ITEM_NOT_FOUND            : result:= sERROR_INTERNET_ITEM_NOT_FOUND;
    ERROR_INTERNET_LOGIN_FAILURE             : result:= sERROR_INTERNET_LOGIN_FAILURE;
    ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY : result:= sERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY;
    ERROR_INTERNET_MIXED_SECURITY            : result:= sERROR_INTERNET_MIXED_SECURITY;
    ERROR_INTERNET_NAME_NOT_RESOLVED         : result:= sERROR_INTERNET_NAME_NOT_RESOLVED;
    ERROR_INTERNET_NEED_MSN_SSPI_PKG         : result:= sERROR_INTERNET_NEED_MSN_SSPI_PKG;
    ERROR_INTERNET_NEED_UI                   : result:= sERROR_INTERNET_NEED_UI;
    ERROR_INTERNET_NO_CALLBACK               : result:= sERROR_INTERNET_NO_CALLBACK;
    ERROR_INTERNET_NO_CONTEXT                : result:= sERROR_INTERNET_NO_CONTEXT;
    ERROR_INTERNET_NO_DIRECT_ACCESS          : result:= sERROR_INTERNET_NO_DIRECT_ACCESS;
    ERROR_INTERNET_NOT_INITIALIZED           : result:= sERROR_INTERNET_NOT_INITIALIZED;
    ERROR_INTERNET_NOT_PROXY_REQUEST         : result:= sERROR_INTERNET_NOT_PROXY_REQUEST;
    ERROR_INTERNET_OPERATION_CANCELLED       : result:= sERROR_INTERNET_OPERATION_CANCELLED;
    ERROR_INTERNET_OPTION_NOT_SETTABLE       : result:= sERROR_INTERNET_OPTION_NOT_SETTABLE;
    ERROR_INTERNET_OUT_OF_HANDLES            : result:= sERROR_INTERNET_OUT_OF_HANDLES;
    ERROR_INTERNET_POST_IS_NON_SECURE        : result:= sERROR_INTERNET_POST_IS_NON_SECURE;
    ERROR_INTERNET_PROTOCOL_NOT_FOUND        : result:= sERROR_INTERNET_PROTOCOL_NOT_FOUND;
    ERROR_INTERNET_PROXY_SERVER_UNREACHABLE  : result:= sERROR_INTERNET_PROXY_SERVER_UNREACHABLE;
    ERROR_INTERNET_REDIRECT_SCHEME_CHANGE    : result:= sERROR_INTERNET_REDIRECT_SCHEME_CHANGE;
    ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND  : result:= sERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND;
    ERROR_INTERNET_REQUEST_PENDING           : result:= sERROR_INTERNET_REQUEST_PENDING;
    ERROR_INTERNET_RETRY_DIALOG              : result:= sERROR_INTERNET_RETRY_DIALOG;
    ERROR_INTERNET_SEC_CERT_CN_INVALID       : result:= sERROR_INTERNET_SEC_CERT_CN_INVALID;
    ERROR_INTERNET_SEC_CERT_DATE_INVALID     : result:= sERROR_INTERNET_SEC_CERT_DATE_INVALID;
    ERROR_INTERNET_SEC_CERT_ERRORS           : result:= sERROR_INTERNET_SEC_CERT_ERRORS;
    ERROR_INTERNET_SEC_CERT_NO_REV           : result:= sERROR_INTERNET_SEC_CERT_NO_REV;
    ERROR_INTERNET_SEC_CERT_REVOKED          : result:= sERROR_INTERNET_SEC_CERT_REVOKED;
    ERROR_INTERNET_SEC_INVALID_CERT          : result:= sERROR_INTERNET_SEC_INVALID_CERT;
    ERROR_INTERNET_SECURITY_CHANNEL_ERROR    : result:= sERROR_INTERNET_SECURITY_CHANNEL_ERROR;
    ERROR_INTERNET_SERVER_UNREACHABLE        : result:= sERROR_INTERNET_SERVER_UNREACHABLE;
    ERROR_INTERNET_SHUTDOWN                  : result:= sERROR_INTERNET_SHUTDOWN;
    ERROR_INTERNET_TCPIP_NOT_INSTALLED       : result:= sERROR_INTERNET_TCPIP_NOT_INSTALLED;
    ERROR_INTERNET_TIMEOUT                   : result:= sERROR_INTERNET_TIMEOUT;
    ERROR_INTERNET_UNABLE_TO_CACHE_FILE      : result:= sERROR_INTERNET_UNABLE_TO_CACHE_FILE;
    ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT : result:= sERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT;
    ERROR_INTERNET_UNRECOGNIZED_SCHEME       : result:= sERROR_INTERNET_UNRECOGNIZED_SCHEME;
    ERROR_INVALID_HANDLE                     : result:= sERROR_INVALID_HANDLE;
    ERROR_MORE_DATA                          : result:= sERROR_MORE_DATA;
    ERROR_NO_MORE_FILES                      : result:= sERROR_NO_MORE_FILES;
    ERROR_NO_MORE_ITEMS                      : result:= sERROR_NO_MORE_ITEMS;
    else
      result:=sERROR_UNKNOWN_ERROR;
  end;
end;
procedure RaiseLastAPIError;overload;
var
  LastError: dword;
  Error: EWinInetApiError;
  sMessage:string;
begin
  LastError:=GetLastError;
  if LastError>INTERNET_ERROR_BASE then
  begin
    sMessage:=TranslateAPIErrorCode(LastError);
    Error := EWinInetApiError.CreateResFmt(@sApiError, [sMessage,LastError]);
    Error.ErrorCode := LastError;
    raise Error;

  end
  else
    RaiseLastOSError;
end;
procedure RaiseLastAPIError(LastError: dword);overload;
var
  Error: EWinInetApiError;
  sMessage:string;
begin
  if LastError>INTERNET_ERROR_BASE then
  begin
    sMessage:=TranslateAPIErrorCode(LastError);
    Error := EWinInetApiError.CreateResFmt(@sApiError, [sMessage,LastError]);
    Error.ErrorCode := LastError;
    raise Error;

  end
  else
    RaiseLastOSError;
end;
function APISchemeEnumToNative(APISchemeEnum:integer):TInternetSchemes;
var t:TInternetSchemes;
begin
  result:=isUnknown;
  for t:=low(TInternetSchemes) to high(TInternetSchemes) do
  begin
    if c_InternetAPISchemeMapping[t]=ApiSchemeEnum then
    begin
      result:=t;
      break;
    end;
  end;
end;
{  **** Cracks a URL into its component parts.                                                                          }
{  see http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcrackurl.asp for more details  }
function InternalInternetCrackUrl(
                          Url: string;                        // string that contains the canonical URL to crack
                          options:TInternetURLCrackOptions;   // icoDECODE: Converts encoded characters back to their normal form.
                                                              // icoESCAPE Converts all escape sequences (%xx) to their corresponding characters
                          var UrlComponents: TURL_Components  // TURLCOMPONENTS structure that receives the URL components
                          ): boolean;                         // Returns TRUE if the function succeeds, or FALSE otherwise.
var                                                              //   To get extended error information, "call GetLastError"
  dwFlags: DWORD; // that contains the flags controlling the operation. This can be one of the following values: ICU_DECODE (Converts encoded characters back to their normal form.), ICU_ESCAPE (Converts all escape sequences (%xx) to their corresponding characters)
  aUrlComponents: TURLComponents;
begin
  dwFlags:=0;
  if icoDECODE in options then
    dwFlags:=dwFlags or ICU_DECODE;
  if icoESCAPE in options then
    dwFlags:=dwFlags or ICU_ESCAPE;

  aUrlComponents.dwSchemeLength:=1024;
  aUrlComponents.dwHostNameLength:=1024;
  aUrlComponents.dwUserNameLength:=1024;
  aUrlComponents.dwPasswordLength:=1024;
  aUrlComponents.dwUrlPathLength:=1024;
  aUrlComponents.dwExtraInfoLength:=1024;
  aUrlComponents.dwStructSize:=sizeof(aUrlComponents);
  getMem(aUrlComponents.lpszScheme,aUrlComponents.dwSchemeLength);
  getMem(aUrlComponents.lpszHostName,aUrlComponents.dwHostNameLength);
  getMem(aUrlComponents.lpszUserName,aUrlComponents.dwUserNameLength);
  getMem(aUrlComponents.lpszPassword,aUrlComponents.dwPasswordLength);
  getMem(aUrlComponents.lpszUrlPath,aUrlComponents.dwUrlPathLength);
  getMem(aUrlComponents.lpszExtraInfo,aUrlComponents.dwExtraInfoLength);
  try
    result:=boolean(InternetCrackUrl(pchar(Url),0, dwFlags,aUrlComponents));
    if result then
    begin
      UrlComponents.Scheme:=string(aUrlComponents.lpszScheme);
      UrlComponents.nScheme:=APISchemeEnumToNative(aUrlComponents.nScheme);
      UrlComponents.HostName:=string(aUrlComponents.lpszHostName);
      UrlComponents.nPort:=aUrlComponents.nPort;
      UrlComponents.pad:=aUrlComponents.pad;
      UrlComponents.UserName:=string(aUrlComponents.lpszUserName);
      UrlComponents.Password:=string(aUrlComponents.lpszPassword);
      UrlComponents.UrlPath:=string(aUrlComponents.lpszUrlPath);
      UrlComponents.ExtraInfo:=string(aUrlComponents.lpszExtraInfo);
    end;
  finally
    freeMem(aUrlComponents.lpszScheme,aUrlComponents.dwSchemeLength);
    freeMem(aUrlComponents.lpszHostName,aUrlComponents.dwHostNameLength);
    freeMem(aUrlComponents.lpszUserName,aUrlComponents.dwUserNameLength);
    freeMem(aUrlComponents.lpszPassword,aUrlComponents.dwPasswordLength);
    freeMem(aUrlComponents.lpszUrlPath,aUrlComponents.dwUrlPathLength);
    freeMem(aUrlComponents.lpszExtraInfo,aUrlComponents.dwExtraInfoLength);
  end;
end;
{***************************************** END OF "InternalInternetCrackUrl" *******************************************}

{TINETApi_Options}
constructor TINETApi_Options.Create(aOwner:TCustomInternetComponent);
begin
  inherited Create;
  fOwner:=aOwner;
  fErrorMask:=$00000000; //lowest security value;
end;
destructor  TINETApi_Options.destroy;
begin
  inherited Destroy;
end;

{***********************************************************************************************************************}
{*************************************** PROTECTED METHODS OF TINETApi_Intf Class **************************************}
{***********************************************************************************************************************}
function  TINETApi_Options.getHandle:HINTERNET;
begin
  result:=nil;
  if assigned(Owner) then
    result:=Owner.getHandle;
end;
procedure TINETApi_Options.getPtrOption(option:dword;BufferToGet:pointer);
var
  res:boolean;
  dwBufferLength:dword;
begin
  dwBufferLength:=0;
  if not InternetQueryOption(nil, Option, nil, dwBufferLength) then// retrieve required buffer size
    dwBufferLength:=4;
  res:=boolean(InternetQueryOption(Handle, Option, BufferToGet, dwBufferLength));
  if not res then
    RaiseLastAPIError;
end;
procedure TINETApi_Options.setPtrOption(option:dword;BufferToSet:pointer);
var
  res:boolean;
  dwBufferLength:dword;
begin
  dwBufferLength:=0;
  InternetQueryOption(nil, Option, nil, dwBufferLength); // retrieve required buffer size
  res:=boolean(InternetSetOption(Handle, Option, BufferToSet, dwBufferLength));
  if not res then
    RaiseLastAPIError;
end;

function  TINETApi_Options.getIntOption(option:dword):dword;
begin
  result:=0;
  getPtrOption(option,@result);
end;
procedure TINETApi_Options.setIntOption(option:dword;aValue:dword);
begin
  setPtrOption(option,@aValue);
end;
function  TINETApi_Options.getBoolOption(option:dword):boolean;
var
  Temp: bool;
begin
  getPtrOption(option,@Temp);
  result:=boolean(Temp);
end;
procedure TINETApi_Options.setBoolOption(option:dword;aValue:boolean);
var
  Temp: bool;
begin
  temp:=bool(aValue);
  setPtrOption(option,@Temp);
end;

function  TINETApi_Options.getStrOption(option:dword):string;
var
  p:pchar;
  dwBufferLength:dword;
  res:boolean;
begin
  dwBufferLength:=0;
  InternetQueryOption(Handle, Option, nil, dwBufferLength); // retrieve required buffer size
  getMem(p,dwBufferLength);
  try
    res:=boolean(InternetQueryOption(Handle, Option, p, dwBufferLength));
    if not res then
      RaiseLastAPIError;
  finally
    freeMem(p,dwBufferLength);
  end;
end;
procedure TINETApi_Options.setStrOption(option:dword;aValue:string);
var
  p:pchar;
  dwBufferLength:dword;
  res:boolean;
begin
  //allocate memory length +1 for null terminator
  dwBufferLength := length(aValue) + 1;
  getMem(p,dwBufferLength);
  try
    res:=boolean(InternetSetOption(Handle, Option, p, dwBufferLength));
    if not res then
      RaiseLastAPIError;
  finally
    freeMem(p,dwBufferLength);
  end;
end;
function  TINETApi_Options.getASYNC:boolean;                     // Not currently implemented by MS-INET API.
begin
  result:=getBoolOption(INTERNET_OPTION_ASYNC);
end;

procedure TINETApi_Options.setASYNC(p:boolean);                  // Not currently implemented by MS-INET API.
begin
  setBoolOption(INTERNET_OPTION_ASYNC,p);
end;

function  TINETApi_Options.getASYNC_ID:string;                   // Not implemented by MS-INET API.
begin
  result:=getStrOption(INTERNET_OPTION_ASYNC_ID);
end;

procedure TINETApi_Options. setASYNC_ID(p:string);               // Not implemented by MS-INET API.
begin
  setStrOption(INTERNET_OPTION_ASYNC_ID,p);
end;

function  TINETApi_Options.getASYNC_PRIORITY:dword;              // Not currently implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_ASYNC_PRIORITY);
end;

procedure TINETApi_Options. setASYNC_PRIORITY(p:dword);          // Not currently implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_ASYNC_PRIORITY,p);
end;

function  TINETApi_Options.getBYPASS_EDITED_ENTRY:boolean;       // Gets INTERNET_OPTION_BYPASS_EDITED_ENTRY option.
begin
  result:=getBoolOption(INTERNET_OPTION_BYPASS_EDITED_ENTRY);
end;

procedure TINETApi_Options.setBYPASS_EDITED_ENTRY(p:boolean);    // Sets INTERNET_OPTION_BYPASS_EDITED_ENTRY option.
begin
  setBoolOption(INTERNET_OPTION_BYPASS_EDITED_ENTRY,p);
end;

function  TINETApi_Options.getCACHE_STREAM_HANDLE:dword;         // No longer supported by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_CACHE_STREAM_HANDLE);
end;

procedure TINETApi_Options.setCACHE_STREAM_HANDLE(p:dword);      // No longer supported by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_CACHE_STREAM_HANDLE,p);
end;

function  TINETApi_Options.getCACHE_TIMESTAMPS:INTERNET_CACHE_TIMESTAMPS;     //Gets INTERNET_OPTION_CACHE_TIMESTAMPS option.
begin
  getPtrOption(INTERNET_OPTION_CACHE_TIMESTAMPS,@result);
end;

procedure TINETApi_Options.setCACHE_TIMESTAMPS(p:INTERNET_CACHE_TIMESTAMPS);  //Sets INTERNET_OPTION_CACHE_TIMESTAMPS option.
begin
  setPtrOption(INTERNET_OPTION_CACHE_TIMESTAMPS,@p);
end;

function  TINETApi_Options.getCACHE_Expires:TDatetime;           // Gets ftExpires part of CACHE_TIMESTAMPS
var sysTime:TSystemTime;
begin
  FileTimeToSystemTime(CACHE_TIMESTAMPS.ftExpires,sysTime);
  result:=SystemTimeToDateTime(systime)
end;

procedure TINETApi_Options.setCACHE_Expires(p:TDateTime);        // Sets ftExpires part of CACHE_TIMESTAMPS
var
 sysTime:TSystemTime;
 fileTime:TFileTime;
 pc:INTERNET_CACHE_TIMESTAMPS;
begin
  DateTimeToSystemTime(p,sysTime);
  SystemTimeToFileTime(sysTime,fileTime);
  pc:=getCACHE_TIMESTAMPS;
  pc.ftExpires:=fileTime;
  setCACHE_TIMESTAMPS(pc);
end;

function  TINETApi_Options.getCACHE_LastModified:TDatetime;      // Gets ftLastModified part of CACHE_TIMESTAMPS
var sysTime:TSystemTime;
begin
  FileTimeToSystemTime(CACHE_TIMESTAMPS.ftLastModified,sysTime);
  result:=SystemTimeToDateTime(systime)
end;

procedure TINETApi_Options.setCACHE_LastModified(p:TDatetime);   // Sets ftLastModified part of CACHE_TIMESTAMPS
var
 sysTime:TSystemTime;
 fileTime:TFileTime;
 pc:INTERNET_CACHE_TIMESTAMPS;
begin
  DateTimeToSystemTime(p,sysTime);
  SystemTimeToFileTime(sysTime,fileTime);
  pc:=getCACHE_TIMESTAMPS;
  pc.ftLastModified:=fileTime;
  setCACHE_TIMESTAMPS(pc);
end;

function  TINETApi_Options.getCALLBACK:INTERNET_STATUS_CALLBACK;      // Retrieves the address of the callback function defined for this handle.
begin
  getPtrOption(INTERNET_OPTION_CALLBACK,@result);
end;

procedure TINETApi_Options.setCALLBACK(p:INTERNET_STATUS_CALLBACK);   // Sets the address of the callback function defined for this handle.
begin
  setPtrOption(INTERNET_OPTION_CALLBACK,@p);
end;

function  TINETApi_Options.getCALLBACK_FILTER:dword;             // Not currently implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_CALLBACK_FILTER);
end;

procedure TINETApi_Options. setCALLBACK_FILTER(p:dword);         // Not currently implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_CALLBACK_FILTER,p);
end;

function  TINETApi_Options.getCODEPAGE:string;                   // Not currently implemented by MS-INET API.
begin
  result:=getStrOption(INTERNET_OPTION_CODEPAGE);
end;

procedure TINETApi_Options. setCODEPAGE(p:string);               // Not currently implemented by MS-INET API.
begin
  setStrOption(INTERNET_OPTION_CODEPAGE,p);
end;

function  TINETApi_Options.getCONNECT_RETRIES:dword;             // Retrieves INTERNET_OPTION_CONNECT_RETRIES option. See "CONNECT_RETRIES" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_CONNECT_RETRIES);
end;

procedure TINETApi_Options. setCONNECT_RETRIES(p:dword);         // Sets INTERNET_OPTION_CONNECT_RETRIES option. See "CONNECT_RETRIES" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_CONNECT_RETRIES,p);
end;

function  TINETApi_Options.getCONNECT_TIMEOUT:dword;             // Retrieves INTERNET_OPTION_CONNECT_TIMEOUT option. see "CONNECT_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_CONNECT_TIMEOUT);
end;

procedure TINETApi_Options.setCONNECT_TIMEOUT(p:dword);          // Sets INTERNET_OPTION_CONNECT_TIMEOUT option. see "CONNECT_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_CONNECT_TIMEOUT,p);
end;

function  TINETApi_Options.getCONNECTED_STATE:dword;             // Retrieves INTERNET_OPTION_CONNECTED_STATE option. see "CONNECTED_STATE" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_CONNECTED_STATE);
end;

procedure TINETApi_Options.setCONNECTED_STATE(p:dword);          // Sets INTERNET_OPTION_CONNECTED_STATE option. see "CONNECTED_STATE" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_CONNECTED_STATE,p);
end;

function  TINETApi_Options.getCONTEXT_VALUE:pointer;             // Retrieves INTERNET_OPTION_CONTEXT_VALUE option. see "CONTEXT_VALUE" property declaration for more information.
begin
  result:=nil;
  getPtrOption(INTERNET_OPTION_CONTEXT_VALUE,result);
end;

procedure TINETApi_Options.setCONTEXT_VALUE(p:pointer);          // Sets INTERNET_OPTION_CONTEXT_VALUE option. see "CONTEXT_VALUE" property for declaration more information.
begin
  setPtrOption(INTERNET_OPTION_CONTEXT_VALUE,p);
end;

function  TINETApi_Options.getCONTROL_RECEIVE_TIMEOUT:dword;     // Retrieves INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT);
end;

procedure TINETApi_Options.setCONTROL_RECEIVE_TIMEOUT(p:dword);  // Sets INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT,p);
end;

function  TINETApi_Options.getCONTROL_SEND_TIMEOUT:dword;        // Retrieves INTERNET_OPTION_CONTROL_SEND_TIMEOUT option. see "CONTROL_SEND_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_CONTROL_SEND_TIMEOUT);
end;

procedure TINETApi_Options.setCONTROL_SEND_TIMEOUT(p:dword);     // Gets INTERNET_OPTION_CONTROL_SEND_TIMEOUT option. see "CONTROL_SEND_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_CONTROL_SEND_TIMEOUT,p);
end;

function  TINETApi_Options.getDATA_RECEIVE_TIMEOUT:dword;        // Not implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_DATA_RECEIVE_TIMEOUT);
end;

procedure TINETApi_Options. setDATA_RECEIVE_TIMEOUT(p:dword);    // Not implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_DATA_RECEIVE_TIMEOUT,p);
end;

function  TINETApi_Options.getDATA_SEND_TIMEOUT:dword;           // Not implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_DATA_SEND_TIMEOUT);
end;

procedure TINETApi_Options.setDATA_SEND_TIMEOUT(p:dword);        // Not implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_DATA_SEND_TIMEOUT,p);
end;

function  TINETApi_Options.getDATAFILE_NAME:string;              // Retrieves INTERNET_OPTION_DATAFILE_NAME option. see "DATAFILE_NAME" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_DATAFILE_NAME);
end;

procedure TINETApi_Options.setDATAFILE_NAME(p:string);           // Gets INTERNET_OPTION_DATAFILE_NAME option. see "DATAFILE_NAME" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_DATAFILE_NAME,p);
end;

function  TINETApi_Options.getDISABLE_AUTODIAL:boolean;          // Not currently implemented by MS-INET API.
begin
  result:=getBoolOption(INTERNET_OPTION_DISABLE_AUTODIAL);
end;

procedure TINETApi_Options.setDISABLE_AUTODIAL(p:boolean);       // Not currently implemented by MS-INET API.
begin
  setBoolOption(INTERNET_OPTION_DISABLE_AUTODIAL,p);
end;

function  TINETApi_Options.getDISCONNECTED_TIMEOUT:dword;        // Not currently implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_DISCONNECTED_TIMEOUT);
end;

procedure TINETApi_Options. setDISCONNECTED_TIMEOUT(p:dword);    // Not currently implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_DISCONNECTED_TIMEOUT,p);
end;

function  TINETApi_Options.getERROR_MASK:dword;                  // Retrieves INTERNET_OPTION_ERROR_MASK option. see "ERROR_MASK" property declaration for more information.
begin
  //INTERNET_ERROR_MASK HAS ONLY WRITE PERMISSION!
  result:=fErrorMask;
end;

//need to use local copy for getERROR_MASK!!!
procedure TINETApi_Options.setERROR_MASK(p:dword);               // Sets INTERNET_OPTION_ERROR_MASK option. see "ERROR_MASK" property declaration for more information.
begin
  fErrorMask:=p;
  setIntOption(INTERNET_OPTION_ERROR_MASK,p);
end;

function  TINETApi_Options.get_is_error_mask_COMBINED_SEC_CERT:boolean;       //Retrieves "COMBINED_SEC_CERT" flag of "ERROR_MASK" property.
begin
  result:=(fErrorMask and INTERNET_ERROR_MASK_COMBINED_SEC_CERT)>0;
end;

procedure TINETApi_Options.set_is_error_mask_COMBINED_SEC_CERT(p:boolean);    //Sets "COMBINED_SEC_CERT" flag of "ERROR_MASK" property.
begin
  if is_error_mask_COMBINED_SEC_CERT<>p then
  begin
    ERROR_MASK := fErrorMask xor INTERNET_ERROR_MASK_COMBINED_SEC_CERT;
  end;
end;

function  TINETApi_Options.get_is_error_mask_INSERT_CDROM:boolean;            //Retrieves "INSERT_CDROM" flag of "ERROR_MASK" property.
begin
  result:=(fErrorMask and INTERNET_ERROR_MASK_INSERT_CDROM)>0;
end;

procedure TINETApi_Options.set_is_error_mask_INSERT_CDROM(p:boolean);         //Sets "INSERT_CDROM" flag of "ERROR_MASK" property.
begin
  if is_error_mask_INSERT_CDROM<>p then
  begin
    ERROR_MASK := fErrorMask xor INTERNET_ERROR_MASK_INSERT_CDROM;
  end;
end;

function  TINETApi_Options.get_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY:boolean;     //Retrieves "LOGIN_FAILURE_DISPLAY_ENTITY_BODY" flag of "ERROR_MASK" property.
begin
  result:=(fErrorMask and INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY)>0;
end;

procedure TINETApi_Options.set_is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY(p:boolean);  //Sets "LOGIN_FAILURE_DISPLAY_ENTITY_BODY" flag of "ERROR_MASK" property.
begin
  if is_error_mask_LOGIN_FAILURE_DISPLAY_ENTITY_BODY<>p then
  begin
    ERROR_MASK := fErrorMask xor INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY;
  end;
end;

function  TINETApi_Options.get_is_error_mask_NEED_MSN_SSPI_PKG:boolean;                     //Retrieves "NEED_MSN_SSPI_PKG" flag of "ERROR_MASK" property.
begin
  result:=(fErrorMask and INTERNET_ERROR_MASK_NEED_MSN_SSPI_PKG)>0;
end;

procedure TINETApi_Options.set_is_error_mask_NEED_MSN_SSPI_PKG(p:boolean);                  //Sets "NEED_MSN_SSPI_PKG" flag of "ERROR_MASK" property.
begin
  if is_error_mask_NEED_MSN_SSPI_PKG<>p then
  begin
    ERROR_MASK := fErrorMask xor INTERNET_ERROR_MASK_NEED_MSN_SSPI_PKG;
  end;
end;

// Retrieves an unsigned long integer value that contains a Microsoft Windows® Sockets error code that was mapped to the ERROR_INTERNET_ error
// messages last returned in this thread context. This option is used on a NULLHINTERNET handle by InternetQueryOption.
function  TINETApi_Options.getEXTENDED_ERROR:dword;               // Retrieves INTERNET_OPTION_EXTENDED_ERROR option.
var
  res:boolean;
  dwBufferLength:dword;
begin
  dwBufferLength:=0;
  InternetQueryOption(nil, INTERNET_OPTION_EXTENDED_ERROR, nil, dwBufferLength); // retrieve required buffer size
  res:=boolean(InternetQueryOption(nil, INTERNET_OPTION_EXTENDED_ERROR, @result, dwBufferLength));
  if not res then
    RaiseLastAPIError;
end;
function  TINETApi_Options.getFROM_CACHE_TIMEOUT:dword;           // Retrieves INTERNET_OPTION_FROM_CACHE_TIMEOUT option. see "FROM_CACHE_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_FROM_CACHE_TIMEOUT);
end;

procedure TINETApi_Options. setFROM_CACHE_TIMEOUT(p:dword);       // Sets INTERNET_OPTION_FROM_CACHE_TIMEOUT option. see "FROM_CACHE_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_FROM_CACHE_TIMEOUT,p);
end;

function  TINETApi_Options.getHANDLE_TYPE:TInternetHandleTypes;   // Retrieves current type of internet handle.
var
  dwHandleType:dword;
  t:TInternetHandleTypes;
begin
  result:=ihtUnknown;
  if not assigned(Handle) then exit;
  dwHandleType:=getIntOption(INTERNET_OPTION_HANDLE_TYPE);
  for t:=low(TInternetHandleTypes) to high(TInternetHandleTypes) do
    if c_InternetHandleTypeWINInetMapping[t]=dwHandleType then
    begin
      result:=t;
      break;
    end;
end;

function  TINETApi_Options.getHTTP_VERSION:HTTP_VERSION_INFO;      // Retrieves INTERNET_OPTION_HTTP_VERSION option. see "HTTP_VERSION" property declaration for more information.
begin
  getPtrOption(INTERNET_OPTION_HTTP_VERSION, @result);
end;

procedure TINETApi_Options.setHTTP_VERSION(p:HTTP_VERSION_INFO);   // Sets INTERNET_OPTION_HTTP_VERSION option. see "HTTP_VERSION" property declaration for more information.
begin
  setPtrOption(INTERNET_OPTION_HTTP_VERSION, @p);
end;

function  TINETApi_Options.getIGNORE_OFFLINE:boolean;             // Retrieves INTERNET_OPTION_IGNORE_OFFLINE option. see "IGNORE_OFFLINE" property declaration for more information.
begin
  result:=getBoolOption(INTERNET_OPTION_IGNORE_OFFLINE);
end;

procedure TINETApi_Options.setIGNORE_OFFLINE(p:boolean);         // Sets INTERNET_OPTION_IGNORE_OFFLINE option. see "IGNORE_OFFLINE" property declaration for more information.
begin
  setBoolOption(INTERNET_OPTION_IGNORE_OFFLINE,p);
end;

function  TINETApi_Options.getKEEP_CONNECTION:boolean;           // Not currently implemented by MS-INET API.
begin
  result:=getBoolOption(INTERNET_OPTION_KEEP_CONNECTION);
end;

procedure TINETApi_Options.setKEEP_CONNECTION(p:boolean);       // Not currently implemented by MS-INET API.
begin
  setBoolOption(INTERNET_OPTION_KEEP_CONNECTION,p);
end;

function  TINETApi_Options.getLISTEN_TIMEOUT:dword;              // Not currently implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_LISTEN_TIMEOUT);
end;

procedure TINETApi_Options.setLISTEN_TIMEOUT(p:dword);          // Not currently implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_LISTEN_TIMEOUT,p);
end;

function  TINETApi_Options.getMAX_CONNS_PER_1_0_SERVER:dword;   // Retrieves INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER option. see "MAX_CONNS_PER_1_0_SERVER" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER);
end;

procedure TINETApi_Options.setMAX_CONNS_PER_1_0_SERVER(p:dword);// Sets INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER option. see "MAX_CONNS_PER_1_0_SERVER" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER,p);
end;

function  TINETApi_Options.getMAX_CONNS_PER_SERVER:dword;       // Retrieves INTERNET_OPTION_MAX_CONNS_PER_SERVER option. see "MAX_CONNS_PER_SERVER" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_MAX_CONNS_PER_SERVER);
end;

procedure TINETApi_Options.setMAX_CONNS_PER_SERVER(p:dword);    // Sets INTERNET_OPTION_MAX_CONNS_PER_SERVER option. see "MAX_CONNS_PER_SERVER" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_MAX_CONNS_PER_SERVER,p);
end;

function  TINETApi_Options.getOFFLINE_MODE:boolean;             // Not currently implemented by MS-INET API.
begin
  result:=getBoolOption(INTERNET_OPTION_OFFLINE_MODE);
end;

procedure TINETApi_Options.setOFFLINE_MODE(p:boolean);          // Not currently implemented by MS-INET API.
begin
  setBoolOption(INTERNET_OPTION_OFFLINE_MODE,p);
end;

function  TINETApi_Options.getPARENT_HANDLE:HINTERNET;           // Retrieves the parent handle to this handle. This option can be used on any HINTERNET handle by InternetQueryOption.
begin
  getPtrOption(INTERNET_OPTION_PARENT_HANDLE,@result);
end;

function  TINETApi_Options.getPASSWORD:string;                   // Retrieves a string value that contains the password associated with a handle returned by InternetConnect.
begin
  result:=getStrOption(INTERNET_OPTION_PASSWORD);
end;

procedure TINETApi_Options.setPASSWORD(p:string);               // Sets a string value that contains the password associated with a handle returned by InternetConnect.
begin
  setStrOption(INTERNET_OPTION_PASSWORD,p);
end;

function  TINETApi_Options.getPER_CONNECTION_OPTION: INTERNET_PER_CONN_OPTION_LIST;    // Retrieves an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection.
begin
  getPtrOption(INTERNET_OPTION_PER_CONNECTION_OPTION,@result);
end;

procedure TINETApi_Options.setPER_CONNECTION_OPTION(p:INTERNET_PER_CONN_OPTION_LIST); // Sets an INTERNET_PER_CONN_OPTION_LIST structure that specifies a list of options for a particular connection.
begin
  setPtrOption(INTERNET_OPTION_PER_CONNECTION_OPTION,@p);
end;

function  TINETApi_Options.getPOLICY:dword;                      // Not currently implemented by MS-INET API.
begin
  result:=getIntOption(INTERNET_OPTION_POLICY);
end;

procedure TINETApi_Options.setPOLICY(p:dword);                  // Not currently implemented by MS-INET API.
begin
  setIntOption(INTERNET_OPTION_POLICY,p);
end;

function  TINETApi_Options.getPROXY:INTERNET_PROXY_INFO;         // Retrieves INTERNET_OPTION_PROXY option. see "PROXY" property (public) declaration for more information.
begin
  getPtrOption(INTERNET_OPTION_PROXY,@result);
end;

procedure TINETApi_Options.setPROXY(p:INTERNET_PROXY_INFO);     // Sets INTERNET_OPTION_PROXY option. see "PROXY" property (public) declaration for more information.
begin
  setPtrOption(INTERNET_OPTION_PROXY,@p);
end;

function  TINETApi_Options.getPROXY_PASSWORD:string;             // Retrieves INTERNET_OPTION_PROXY_PASSWORD option. see "PROXY_PASSWORD" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_PROXY_PASSWORD);
end;

procedure TINETApi_Options.setPROXY_PASSWORD(p:string);         // Sets INTERNET_OPTION_PROXY_PASSWORD option. see "PROXY_PASSWORD" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_PROXY_PASSWORD,p);
end;

function  TINETApi_Options.getPROXY_USERNAME:string;             // Retrieves INTERNET_OPTION_PROXY_USERNAME option. see "PROXY_USERNAME" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_PROXY_USERNAME);
end;

procedure TINETApi_Options.setPROXY_USERNAME(p:string);         // Sets INTERNET_OPTION_PROXY_USERNAME option. see "PROXY_USERNAME" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_PROXY_USERNAME,p);
end;

function  TINETApi_Options.getREAD_BUFFER_SIZE:dword;            // Retrieves INTERNET_OPTION_READ_BUFFER_SIZE option. see "READ_BUFFER_SIZE" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_READ_BUFFER_SIZE);
end;

procedure TINETApi_Options.setREAD_BUFFER_SIZE(p:dword);        // Sets INTERNET_OPTION_READ_BUFFER_SIZE option. see "READ_BUFFER_SIZE" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_READ_BUFFER_SIZE,p);
end;

function  TINETApi_Options.getRECEIVE_TIMEOUT:dword;             // Retrieves INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_RECEIVE_TIMEOUT);
end;

procedure TINETApi_Options.setRECEIVE_TIMEOUT(p:dword);         // Sets INTERNET_OPTION_RECEIVE_TIMEOUT option. see "RECEIVE_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_RECEIVE_TIMEOUT,p);
end;

function  TINETApi_Options.getREQUEST_FLAGS:dword;               // Retrieves INTERNET_OPTION_REQUEST_FLAGS option. see "REQUEST_FLAGS" property declaration for more information. See also is_req_* properties
begin
  result:=getIntOption(INTERNET_OPTION_REQUEST_FLAGS);
end;



//The INTERNET_OPTION_REQUEST_FLAGS interpreters
function  TINETApi_Options.get_is_req_ASYNC:boolean;                    // Retrieves INTERNET_REQFLAG_ASYNC flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_ASYNC)>0;
end;


function  TINETApi_Options.get_is_req_CACHE_WRITE_DISABLED:boolean;     // Retrieves INTERNET_REQFLAG_CACHE_WRITE_DISABLED flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_CACHE_WRITE_DISABLED)>0;
end;

function  TINETApi_Options.get_is_req_FROM_CACHE:boolean;               // Retrieves INTERNET_REQFLAG_FROM_CACHE flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_FROM_CACHE)>0;
end;

function  TINETApi_Options.get_is_req_NET_TIMEOUT:boolean;              // Retrieves INTERNET_REQFLAG_NET_TIMEOUT flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_NET_TIMEOUT)>0;
end;

function  TINETApi_Options.get_is_req_NO_HEADERS:boolean;               // Retrieves INTERNET_REQFLAG_NO_HEADERS flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_NO_HEADERS)>0;
end;

function  TINETApi_Options.get_is_req_PASSIVE:boolean;                  // Retrieves INTERNET_REQFLAG_PASSIVE flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_PASSIVE)>0;
end;

function  TINETApi_Options.get_is_req_VIA_PROXY:boolean;                // Retrieves INTERNET_REQFLAG_VIA_PROXY flag of REQUEST_FLAGS (INTERNET_OPTION_REQUEST_FLAGS option).
begin
  result:=(REQUEST_FLAGS and INTERNET_REQFLAG_VIA_PROXY)>0;
end;


function  TINETApi_Options.getREQUEST_PRIORITY:dword;                   // Retrieves INTERNET_OPTION_REQUEST_PRIORITY option. see "REQUEST_PRIORITY" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_REQUEST_PRIORITY);
end;

procedure TINETApi_Options.setREQUEST_PRIORITY(p:dword);               // Sets INTERNET_OPTION_REQUEST_PRIORITY option. see "REQUEST_PRIORITY" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_REQUEST_PRIORITY,p);
end;

function  TINETApi_Options.getSECONDARY_CACHE_KEY:string;               // Retrieves INTERNET_OPTION_SECONDARY_CACHE_KEY option. see "SECONDARY_CACHE_KEY" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_SECONDARY_CACHE_KEY);
end;

procedure TINETApi_Options.setSECONDARY_CACHE_KEY(p:string);           // Sets INTERNET_OPTION_SECONDARY_CACHE_KEY option. see "SECONDARY_CACHE_KEY" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_SECONDARY_CACHE_KEY,p);
end;

function  TINETApi_Options.getSECURITY_CERTIFICATE:string;              // Retrieves INTERNET_OPTION_SECURITY_CERTIFICATE option. see "SECURITY_CERTIFICATE" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_SECURITY_CERTIFICATE);
end;

function  TINETApi_Options.getSECURITY_CERTIFICATE_STRUCT:INTERNET_CERTIFICATE_INFO;  // Retrieves INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT option. see "SECURITY_CERTIFICATE_STRUCT" property declaration for more information.
begin
  getPtrOption(INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT,@result);
end;

function  TINETApi_Options.getSECURITY_FLAGS:dword;                     // Retrieves INTERNET_OPTION_SECURITY_FLAGS option. see "SECURITY_FLAGS" property declaration for more information. See also sec_is_* properties which indicate these flags as seperate boolean values.
begin
  result:=getIntOption(INTERNET_OPTION_SECURITY_FLAGS);
end;

// INTERNET_OPTION_SECURITY_FLAGS interpreters (SECURITY_FLAG_*):
function  TINETApi_Options.get_sec_is_128BIT:boolean;                   // Identical to the preferred value SECURITY_FLAG_STRENGTH_STRONG.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_128BIT)>0;
end;

function  TINETApi_Options.get_sec_is_40BIT:boolean;                    // Identical to the preferred value SECURITY_FLAG_STRENGTH_WEAK.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_40BIT)>0;
end;

function  TINETApi_Options.get_sec_is_56BIT:boolean;                    // Identical to the preferred value SECURITY_FLAG_STRENGTH_MEDIUM.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_56BIT)>0;
end;

function  TINETApi_Options.get_sec_is_FORTEZZ_A:boolean;                // Indicates Fortezza has been used to provide secrecy, authentication, and/or integrity for the specified connection.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_FORTEZZA)>0;
end;

function  TINETApi_Options.get_sec_is_IETFSSL4:boolean;                 // Not currently implemented.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IETFSSL4)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_CERT_CN_INVALID:boolean;   // Ignores the ERROR_INTERNET_SEC_CERT_CN_INVALID error message.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_CERT_CN_INVALID)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_CERT_DATE_INVALID:boolean; // Ignores the ERROR_INTERNET_SEC_CERT_DATE_INVALID error message.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_CERT_DATE_INVALID)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_REDIRECT_TO_HTTP:boolean;  // Ignores the ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR error message.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTP)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_REDIRECT_TO_HTTPS:boolean; // Ignores the ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR error message.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_REVOCATION:boolean;        // Ignores certificate revocation problems.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_REVOCATION)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_UNKNOWN_CA:boolean;        // Ignores unknown certificate authority problems.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_UNKNOWN_CA)>0;
end;

function  TINETApi_Options.get_sec_is_IGNORE_WRONG_USAGE:boolean;       // Ignores incorrect usage problems.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_IGNORE_WRONG_USAGE)>0;
end;

function  TINETApi_Options.get_sec_is_NORMALBITNESS:boolean;            // Identical to the value property security_STRENGTH_WEAK.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_NORMALBITNESS)>0;
end;

function  TINETApi_Options.get_sec_is_PCT:boolean;                      // Not currently implemented.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_PCT)>0;
end;

function  TINETApi_Options.get_sec_is_PCT4:boolean;                     // Not currently implemented.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_PCT4)>0;
end;

function  TINETApi_Options.get_sec_is_SECURE:boolean;                   // Uses secure transfers.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_SECURE)>0;
end;

function  TINETApi_Options.get_sec_is_SSL:boolean;                      // Not currently implemented.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_SSL)>0;
end;

function  TINETApi_Options.get_sec_is_SSL3:boolean;                     // Not currently implemented.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_SSL3)>0;
end;

function  TINETApi_Options.get_sec_is_STRENGTH_MEDIUM:boolean;          // Uses medium (56-bit) encryption.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_STRENGTH_MEDIUM)>0;
end;

function  TINETApi_Options.get_sec_is_STRENGTH_STRONG:boolean;          // Uses strong (128-bit) encryption.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_STRENGTH_STRONG)>0;
end;

function  TINETApi_Options.get_sec_is_STRENGTH_WEAK:boolean;            // Uses weak (40-bit) encryption.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_STRENGTH_WEAK)>0;
end;

function  TINETApi_Options.get_sec_is_UNKNOWNBIT:boolean;               // The bit size used in the encryption is unknown.
begin
  result:=(SECURITY_FLAGS and SECURITY_FLAG_UNKNOWNBIT)>0;
end;

function  TINETApi_Options.getSECURITY_KEY_BITNESS:dword;               // Retrieves INTERNET_OPTION_SECURITY_KEY_BITNESS option. see "SECURITY_KEY_BITNESS" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_SECURITY_KEY_BITNESS);
end;

function  TINETApi_Options.getSEND_TIMEOUT:dword;                       // Retrieves INTERNET_OPTION_SEND_TIMEOUT option. see "SEND_TIMEOUT" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_SEND_TIMEOUT);
end;

procedure TINETApi_Options.setSEND_TIMEOUT(p:dword);                   // Sets INTERNET_OPTION_SEND_TIMEOUT option. see "SEND_TIMEOUT" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_SEND_TIMEOUT,p);
end;


function  TINETApi_Options.getURL:string;                               // Retrieves INTERNET_OPTION_URL option. see "URL" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_URL);
end;

function  TINETApi_Options.getUSER_AGENT:string;                        // Retrieves INTERNET_OPTION_USER_AGENT option. see "USER_AGENT" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_USER_AGENT);
end;

procedure TINETApi_Options.setUSER_AGENT(p:string);                    // Sets INTERNET_OPTION_USER_AGENT option. see "USER_AGENT" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_USER_AGENT,p);
end;

function  TINETApi_Options.getUSERNAME:string;                          // Retrieves INTERNET_OPTION_USERNAME option. see "USERNAME" property declaration for more information.
begin
  result:=getStrOption(INTERNET_OPTION_USERNAME);
end;

procedure TINETApi_Options.setUSERNAME(p:string);                      // Sets INTERNET_OPTION_USERNAME option. see "USERNAME" property declaration for more information.
begin
  setStrOption(INTERNET_OPTION_USERNAME,p);
end;

function  TINETApi_Options.getVERSION:INTERNET_VERSION_INFO;            // Retrieves INTERNET_OPTION_VERSION option. see "VERSION" property declaration for more information.
begin
  getPtrOption(INTERNET_OPTION_VERSION,@result);
end;


function  TINETApi_Options.getWRITE_BUFFER_SIZE:dword;                  // Retrieves INTERNET_OPTION_WRITE_BUFFER_SIZE option. see "WRITE_BUFFER_SIZE" property declaration for more information.
begin
  result:=getIntOption(INTERNET_OPTION_WRITE_BUFFER_SIZE);
end;

procedure TINETApi_Options.setWRITE_BUFFER_SIZE(p:dword);              // Sets INTERNET_OPTION_WRITE_BUFFER_SIZE option. see "WRITE_BUFFER_SIZE" property declaration for more information.
begin
  setIntOption(INTERNET_OPTION_WRITE_BUFFER_SIZE,p);
end;


{***********************************************************************************************************************}
{**************************************** PUBLIC METHODS OF TINETApi_Intf Class ****************************************}
{***********************************************************************************************************************}
// Causes the system to log off the Digest authentication SSPI package, purging all of the credentials created for the process.
// No buffer is required for this option. It is used by InternetSetOption.
function TINETApi_Options.DIGEST_AUTH_UNLOAD:boolean;
begin
  result:=boolean(InternetSetOption(Handle, INTERNET_OPTION_DIGEST_AUTH_UNLOAD, nil, 0));
end;
// Flushes entries not in use from the password cache on the hard drive. Also resets the cache time used
// when the synchronization mode is once-per-session. No buffer is required for this option.
// This is used by InternetSetOption.
function TINETApi_Options.END_BROWSER_SESSION:boolean;
begin
  result:=boolean(InternetSetOption(Handle, INTERNET_OPTION_END_BROWSER_SESSION, nil, 0));
end;

// Causes the proxy information to be reread from the registry for a handle. No buffer is required.
// This option can be used on the HINTERNET handle returned by InternetOpen. It is used by InternetSetOption.
// ORGINAL option is INTERNET_OPTION_REFRESH!!!
function TINETApi_Options.REFRESH_PROXY_INFO:boolean;
begin
  result:=boolean(InternetSetOption(Handle, INTERNET_OPTION_REFRESH, nil, 0));
end;

// Starts a new cache session for the process.
// required option value is INTERNET_OPTION_RESET_URLCACHE_SESSION for InternetSetOption
function TINETApi_Options.RESET_URLCACHE_SESSION:boolean;
begin
  result:=boolean(InternetSetOption(Handle, INTERNET_OPTION_RESET_URLCACHE_SESSION, nil, 0));
end;

//Informs the system that the registry settings have been changed so that it will check the settings on the next call to InternetConnect.
function  TINETApi_Options.SETTINGS_CHANGED:boolean;
begin
  result:=boolean(InternetSetOption(Handle, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0));
end;

{-----------------------------------------------------------------------------------------------------------------------}
{---------------------------------------- COMMON API FUNCTION BROKERS --------------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}


{  **** Formats a date and time according to the HTTP version 1.0 specification                                         }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internettimefromsystemtime.asp         }
function TINETApi_Intf.InternalInternetTimeFromSystemTime(
                          const pst: TSystemTime;              // A SYSTEMTIME structure that contains the date and time to format.
                          dwRFC: DWORD;                        // Value that contains the RFC format used.
                                                               //   Currently, the only valid format is INTERNET_RFC1123_FORMAT.
                          var TimeStr: string                  // [out] A string buffer that receives the formatted date and time.
                                                               //    The buffer should be of size INTERNET_RFC1123_BUFSIZE.
                          ): boolean;                          // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                               //    To get extended error information, call GetLastError
var
  p:Pchar;
begin
  getMem(p,INTERNET_RFC1123_BUFSIZE+1);
  result := boolean(InternetTimeFromSystemTime(pst, dwRFC, p, INTERNET_RFC1123_BUFSIZE+1));
  TimeStr:=string(p);
  freeMem(p);
end;
{************************************* END OF "InternalInternetTimeFromSystemTime" *************************************}


{  **** Converts an HTTP time/date string to a SYSTEMTIME structure.                                                    }
{ See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internettimetosystemtime.asp            }
function TINETApi_Intf.InternalInternetTimeToSystemTime(
                          const Time: string;                   // date/time string to convert
                          var pst: TSystemTime;                 // [out] a SYSTEMTIME structure that receives the converted time.
                          dwReserved: DWORD                     // Reserved. Must be set to 0.
                          ): boolean;                           // Returns TRUE if the string was converted, or FALSE otherwise.
                                                                //   To get extended error information, call GetLastError.
var
  //InternetTimeToSystemTime:TInternetTimeToSystemTime;
  hWININET:hModule;
begin
  hWININET:=LoadLibrary('WININET.DLL');
  try
    //InternetTimeToSystemTime:=getProcAddress(hWININET,'InternetTimeToSystemTime');
    //if assigned(InternetTimeToSystemTime) then
      result:=boolean(InternetTimeToSystemTime(pchar(Time),pst, dwReserved))
    //else
    //  RaiseLastOSError;
  finally
    FreeLibrary(hWININET);
  end;
//  raise exception.create('not implemented');
end;
{************************************** END OF "InternalInternetTimeToSystemTime" **************************************}




{  **** Creates a URL from its component parts.                                                                         }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcreateurl.asp for more details }
function TINETApi_Intf.InternalInternetCreateUrl(
                          UrlComponents: TURL_Components;     // A TURLComponents structure that contains the components from which to create the URL.
                          options:TInternetURLCrackOptions;  // that contains the flags that control the operation of this function. This can be one or both of these values:
                                                             //    ICU_ESCAPE   : Converts all escape sequences (%xx) to their corresponding characters.
                                                             //    ICU_USERNAME : When adding the user name, uses the name that was specified at logon time.
                          var Url: string                    // A string variable  that receives the URL.
                          ): boolean;                        // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                             //    To get extended error information, call GetLastError.
var
  p:pchar;
  dwUrlLength: DWORD;
  dwFlags: DWORD; // that contains the flags controlling the operation. This can be one of the following values: ICU_DECODE (Converts encoded characters back to their normal form.), ICU_ESCAPE (Converts all escape sequences (%xx) to their corresponding characters)
  aUrlComponents: TURLComponents;
begin
  if UrlComponents.Scheme<>'' then
  begin
    aUrlComponents.dwSchemeLength:=length(UrlComponents.Scheme);
    aUrlComponents.lpszScheme:=pchar(UrlComponents.Scheme);
  end
  else
  begin
    aUrlComponents.dwSchemeLength:=0;
    aUrlComponents.lpszScheme:=nil;
  end;
  if UrlComponents.HostName<>'' then
  begin
    aUrlComponents.dwHostNameLength:=length(UrlComponents.HostName);
    aUrlComponents.lpszHostName:=pchar(UrlComponents.HostName);
  end
  else
  begin
    aUrlComponents.dwHostNameLength:=0;
    aUrlComponents.lpszHostName:=nil;
  end;
  if UrlComponents.UserName<>'' then
  begin
    aUrlComponents.dwUserNameLength:=length(UrlComponents.UserName);
    aUrlComponents.lpszUserName:=pchar(UrlComponents.UserName);
  end
  else
  begin
    aUrlComponents.dwUserNameLength:=0;
    aUrlComponents.lpszUserName:=nil;
  end;
  if UrlComponents.Password<>'' then
  begin
    aUrlComponents.dwPasswordLength:=length(UrlComponents.Password);
    aUrlComponents.lpszPassword:=pchar(UrlComponents.Password);
  end
  else
  begin
    aUrlComponents.dwPasswordLength:=0;
    aUrlComponents.lpszPassword:=nil;
  end;
  if UrlComponents.UrlPath<>'' then
  begin
    aUrlComponents.dwUrlPathLength:=length(UrlComponents.UrlPath);
    aUrlComponents.lpszUrlPath:=pchar(UrlComponents.UrlPath);
  end
  else
  begin
    aUrlComponents.dwUrlPathLength:=0;
    aUrlComponents.lpszUrlPath:=nil;
  end;
  if UrlComponents.ExtraInfo<>'' then
  begin
    aUrlComponents.dwExtraInfoLength:=length(UrlComponents.ExtraInfo);
    aUrlComponents.lpszExtraInfo:=pchar(UrlComponents.ExtraInfo);
  end
  else
  begin
    aUrlComponents.dwExtraInfoLength:=0;
    aUrlComponents.lpszExtraInfo:=nil;
  end;

  aUrlComponents.dwStructSize:=sizeof(aUrlComponents);
  aUrlComponents.nScheme:=c_InternetAPISchemeMapping[UrlComponents.nScheme];
  aUrlComponents.nPort:=UrlComponents.nPort;
  aUrlComponents.pad:=UrlComponents.pad;
  dwFlags:=0;
  if icoDECODE in options then
    dwFlags:=dwFlags or ICU_DECODE;
  if icoESCAPE in options then
    dwFlags:=dwFlags or ICU_ESCAPE;
  if icoUSERNAME in options then
    dwFlags:=dwFlags or ICU_USERNAME;

  dwUrlLength:=1024;
  getMem(p,dwUrlLength);
  try
    result:=boolean(InternetCreateUrl(aUrlComponents, dwFlags, p, dwUrlLength));
    if result then
      URL:=string(p);
  finally
    freeMem(p);
  end;
end;
{***************************************** END OF "InternalInternetCreateUrl" ******************************************}


{  **** Canonicalizes a URL, which includes converting unsafe characters and spaces into escape sequences.              }
{  see http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcanonicalizeurl.asp            }
function TINETApi_Intf.InternalInternetCanonicalizeUrl(
                          const Url: string;                 // The string that contains the URL to canonicalize.
                          var Buffer: string;                // the buffer that receives the resulting canonicalized URL.
                          dwFlags: DWORD                     // that contains the flags that control canonicalization.
                                                             //    If no flags are specified (dwFlags = 0), the function converts all unsafe characters and
                                                             //    meta sequences (such as \.,\ .., and \...) to escape sequences.
                                                             //    dwFlags can be one of the following values:
                                                             //    ICU_BROWSER_MODE       : Does not encode or decode characters after "#" or "?", and does not remove trailing white space after "?". If this value is not specified, the entire URL is encoded and trailing white space is removed.
                                                             //    ICU_DECODE             : Converts all %XX sequences to characters, including escape sequences, before the URL is parsed.
                                                             //    ICU_ENCODE_PERCENT     : Encodes any percent signs encountered. By default, percent signs are not encoded. This value is available in Microsoft® Internet Explorer 5 and later versions of the Microsoft Win32® Internet functions.
                                                             //    ICU_ENCODE_SPACES_ONLY : Encodes spaces only.
                                                             //    ICU_NO_ENCODE          : Does not convert unsafe characters to escape sequences.
                                                             //    ICU_NO_META            : Does not remove meta sequences (such as "." and "..") from the URL.
                          ): boolean;                        // Returns TRUE if successful, or FALSE otherwise.
                                                             //    To get extended error information, call GetLastError.
                                                             //    Possible errors include:
                                                             //    ERROR_BAD_PATHNAME         : The URL could not be canonicalized. This flag is valid for Internet Explorer 5 and later versions of the Win32 Internet API.
                                                             //    ERROR_INSUFFICIENT_BUFFER  : The canonicalized URL is too large to fit in the buffer provided. The lpdwBufferLength parameter is set to the size, in bytes, of the buffer required to hold the canonicalized URL.
                                                             //    ERROR_INTERNET_INVALID_URL : The format of the URL is invalid.
                                                             //    ERROR_INVALID_PARAMETER    : There is an invalid string, buffer, buffer size, or flags parameter.
var
  p:pchar;
  dwUrlLength: DWORD;
begin
  dwUrlLength:=1024;
  getMem(p,dwUrlLength);
  result:=boolean(InternetCanonicalizeUrl(pchar(URL), p, dwUrlLength,dwFlags));
  Buffer:=string(p);
  freeMem(p);
end;
{************************************** END OF "InternalInternetCanonicalizeUrl" ***************************************}


{  **** Combines a base and relative URL into a single URL. The resultant URL will be canonicalized.                    }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetcombineurl.asp                 }
function TINETApi_Intf.InternalInternetCombineUrl(
                          const BaseUrl: string;             // A string variable that contains the base URL.
                          const RelativeUrl: string;         // A string variable that contains the relative URL.
                          var Buffer: string;                // A buffer that receives the combined URL
                          dwFlags: DWORD                     // That contains the flags controlling the operation of the function.
                                                             //    This can be one of the following values:
                                                             //    ICU_BROWSER_MODE       : Does not encode or decode characters after "#" or "?", and does not remove trailing white space after "?". If this value is not specified, the entire URL is encoded and trailing white space is removed.
                                                             //    ICU_DECODE             : Converts all %XX sequences to characters, including escape sequences, before the URL is parsed.
                                                             //    ICU_ENCODE_PERCENT     : Encodes any percent signs encountered. By default, percent signs are not encoded. This value is available in Microsoft® Internet Explorer 5 and later versions of the Microsoft Win32® Internet functions.
                                                             //    ICU_ENCODE_SPACES_ONLY : Encodes spaces only.
                                                             //    ICU_NO_ENCODE          : Does not convert unsafe characters to escape sequences.
                                                             //    ICU_NO_META            : Does not remove meta sequences (such as "." and "..") from the URL.
                           ): boolean;                       // Returns TRUE if successful, or FALSE otherwise.
                                                             //    To get extended error information, call GetLastError.
                                                             //    Possible errors include:
                                                             //    ERROR_BAD_PATHNAME         : The URL could not be canonicalized. This flag is valid for Internet Explorer 5 and later versions of the Win32 Internet API.
                                                             //    ERROR_INSUFFICIENT_BUFFER  : The canonicalized URL is too large to fit in the buffer provided. The lpdwBufferLength parameter is set to the size, in bytes, of the buffer required to hold the canonicalized URL.
                                                             //    ERROR_INTERNET_INVALID_URL : The format of the URL is invalid.
                                                             //    ERROR_INVALID_PARAMETER    : There is an invalid string, buffer, buffer size, or flags parameter.

var
  p:pchar;
  dwUrlLength: DWORD;
begin
  dwUrlLength:=1024;
  getMem(p,dwUrlLength);
  result:=boolean(InternetCombineUrl(pchar(BaseUrl), pchar(RelativeUrl), p, dwUrlLength, dwFlags));
  Buffer:=string(p);
  freeMem(p);
end;
{**************************************** END OF "InternalInternetCombineUrl" ******************************************}


{  **** Initializes an application's use of the Microsoft® Win32® Internet functions.                                   }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetopen.asp for more detail       }
function TINETApi_Intf.InternalInternetOpen(
                       Agent: String;                         // a string variable that contains the name of the application or entity calling the Internet functions (for example, Microsoft Internet Explorer). This name is used as the user agent in the HTTP protocol
                       dwAccessType: DWORD;                   // Type of access required. This can be one of the following values
                                                              //   INTERNET_OPEN_TYPE_DIRECT    : Resolves all host names locally
                                                              //   INTERNET_OPEN_TYPE_PRECONFIG : Retrieves the proxy or direct configuration from the registry.
                                                              //   INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY : Retrieves the proxy or direct configuration from the registry and prevents the use of a startup Microsoft JScript® or Internet Setup (INS) file
                                                              //   INTERNET_OPEN_TYPE_PROXY     : Passes requests to the proxy unless a proxy bypass list is supplied and the name to be resolved bypasses the proxy. In this case, the function uses INTERNET_OPEN_TYPE_DIRECT.
                       Proxy: string;                         // A string variable that contains the name of the proxy server(s) to use when proxy access is specified by setting dwAccessType to INTERNET_OPEN_TYPE_PROXY.
                                                              //   Do not use an empty string, because InternetOpen will use it as the proxy name. The Win32 Internet functions recognize only CERN type proxies (HTTP only) and the TIS FTP gateway (FTP only).
                                                              //   If Internet Explorer is installed, the Win32 Internet functions also support SOCKS proxies.
                                                              //   FTP and Gopher requests can be made through a CERN type proxy either by changing them to an HTTP request or by using InternetOpenUrl.
                                                              //   If dwAccessType is not set to INTERNET_OPEN_TYPE_PROXY, this parameter is ignored and should be set to NULL.
                       ProxyBypass: string;                   // a string variable that contains an optional list of host names or IP addresses, or both, that should not be routed through the proxy when dwAccessType is set to INTERNET_OPEN_TYPE_PROXY.
                                                              //   The list can contain wildcards. Do not use an empty string, because InternetOpen will use it as the proxy bypass list.
                                                              //   If this parameter specifies the "<local>" macro as the only entry, the function bypasses any host name that does not contain a period.
                                                              //   If dwAccessType is not set to INTERNET_OPEN_TYPE_PROXY, this parameter is ignored and should be set to NULL
                       dwFlags: DWORD                         // that contains the flags that indicate various options affecting the behavior of the function.
                                                              //   This can be a combination of these values:
                                                              //   INTERNET_FLAG_ASYNC      : Makes only asynchronous requests on handles descended from the handle returned from this function.
                                                              //   INTERNET_FLAG_FROM_CACHE : Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned.
                                                              //   INTERNET_FLAG_OFFLINE    : Identical to INTERNET_FLAG_FROM_CACHE. Does not make network requests.
                       ): HINTERNET;                          // Returns a valid handle that the application passes to subsequent Win32 Internet functions. If InternetOpen fails, it returns NULL.
                                                              //   To retrieve a specific error message, call GetLastError.

var
  pProxy:pchar;
  pProxyBypass:pchar;
begin
  pProxy:=nil;
  pProxyBypass:=nil;
  if Proxy<>'' then
    pProxy:=pchar(Proxy);
  if ProxyBypass<>'' then
    pProxyBypass:=pchar(ProxyBypass);
  result:=InternetOpen(pchar(Agent), dwAccessType, pProxy, pProxyBypass, dwFlags);
end;
{******************************************* END OF "InternalInternetOpen" *********************************************}


{  **** Opens an File Transfer Protocol (FTP), Gopher, or HTTP session for a given site.                                }
{  See  http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetconnect.asp  for more details }
function TINETApi_Intf.InternalInternetConnect(
                       hInet: HINTERNET;                      // Valid HINTERNET handle returned by a previous call to InternalInternetOpen.
                       ServerName: string;                    // string that contains the host name of an Internet server. Alternately, the string can contain the IP number of the site, in ASCII dotted-decimal format (for example, 11.0.1.45).
                       nServerPort: INTERNET_PORT;            // that specifies the Transmission Control Protocol/Internet Protocol (TCP/IP) port on the server. These flags set only the port that is used. The service is set by the value of dwService.
                                                              //    This can be one of the following values:
                                                              //    INTERNET_DEFAULT_FTP_PORT    : Uses the default port for FTP servers (port 21).
                                                              //    INTERNET_DEFAULT_GOPHER_PORT : Uses the default port for Gopher servers (port 70).
                                                              //    INTERNET_DEFAULT_HTTP_PORT   : Uses the default port for HTTP servers (port 80).
                                                              //    INTERNET_DEFAULT_HTTPS_PORT  : Uses the default port for Secure Hypertext Transfer Protocol (HTTPS) servers (port 443).
                                                              //    INTERNET_DEFAULT_SOCKS_PORT  : Uses the default port for SOCKS firewall servers (port 1080).
                                                              //    INTERNET_INVALID_PORT_NUMBER : Uses the default port for the service specified by dwService.
                       Username: string;                      // string that contains the name of the user to log on. If this parameter is NULL, the function uses an appropriate default, except for HTTP;
                                                              //    a NULL parameter in HTTP causes the server to return an error. For the FTP protocol, the default is "anonymous".
                       Password: string;                      // string that contains the password to use to log on. If both Password and Username are NULL, the function uses the default "anonymous" password.
                                                              //    In the case of FTP, the default password is the user's e-mail name.
                                                              //    If Password is NULL, but Username is not NULL, the function uses a blank password.
                       dwService: DWORD;                      // that contains the type of service to access. This can be one of the following values:
                                                              //    INTERNET_SERVICE_FTP    : FTP service.
                                                              //    INTERNET_SERVICE_GOPHER : Gopher service.
                                                              //    INTERNET_SERVICE_HTTP   : HTTP service.
                       dwFlags: DWORD;                        // that contains the flags specific to the service used.
                                                              //    When the value of dwService is INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE causes the application to use passive FTP semantics.
                       dwContext: DWORD                       // an unsigned long integer value that contains an application-defined value that is used to identify the application context for the returned handle in callbacks.
                       ): HINTERNET;                          // Returns a valid handle to the FTP, Gopher, or HTTP session if the connection is successful, or NULL otherwise.
                                                              //    To retrieve extended error information, call GetLastError.
var
  pUsername, pPassword: pchar;
begin
  if Username<>'' then
    pUsername:=pchar(Username)
  else
    pUsername:=nil;
  if Password='' then
    pPassword:=pchar(Password)
  else
    pPassword:=nil;
  result:=InternetConnect(hInet, pchar(ServerName), nServerPort, pUsername, pPassword, dwService, dwFlags, dwContext);
end;
{***************************************** END OF "InternalInternetConnect" ********************************************}


{  **** Closes a single Internet handle.                                                                                }
{  See http://msdn.microsoft.com/networking/wininet/reference/functions/internetclosehandle.asp                         }
function TINETApi_Intf.InternalInternetCloseHandle(
                       hInet: HINTERNET                       // Valid HINTERNET handle to be closed
                       ): boolean;                            // Returns TRUE if the handle is successfully closed, or FALSE otherwise.
                                                              //    To get extended error information, call GetLastError.
begin
  result:=boolean(InternetCloseHandle(hInet));
end;
{*************************************** END OF "InternalInternetCloseHandle" ******************************************}


{  **** Opens a resource specified by a complete FTP, Gopher, or HTTP URL.                                              }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetopenurl.asp                    }
function TINETApi_Intf.InternalInternetOpenUrl(
                       hInet: HINTERNET;                      // HINTERNET handle to the current Internet session. The handle must have been returned by a previous call to InternalInternetOpen.
                       const Url: string;                     // A string variable that contains the URL to begin reading. Only URLs beginning with ftp:, gopher:, http:, or https: are supported.
                       const Headers: string;                 // A string variable that contains the headers to be sent to the HTTP server.
                                                              //    (For more information, see the description of the Headers parameter in the InternalHttpSendRequest function.)
                       dwFlags: DWORD;                        // value that contains the API flags. This can be one of the following values:
                                                              //    INTERNET_FLAG_EXISTING_CONNECT        :Attempts to use an existing InternetConnect object if one exists with the same attributes required to make the request. This is useful only with FTP operations, since FTP is the only protocol that typically performs multiple operations during the same session. The Microsoft® Win32® Internet API caches a single connection handle for each HINTERNET handle generated by InternetOpen.
                                                              //    INTERNET_FLAG_HYPERLINK               :Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
                                                              //    INTERNET_FLAG_IGNORE_CERT_CN_INVALID  :Disables Win32 Internet function checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. Win32 Internet functions use a simple check against certificates by comparing for matching host names and simple wildcarding rules.
                                                              //    INTERNET_FLAG_IGNORE_CERT_DATE_INVALID:Disables Win32 Internet function checking of SSL/PCT-based certificates for proper validity dates.
                                                              //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP :Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTPS to HTTP URLs.
                                                              //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS:Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTP to HTTPS URLs.
                                                              //    INTERNET_FLAG_KEEP_CONNECTION         :Uses keep-alive semantics, if available, for the connection. This flag is required for Microsoft Network (MSN), NT LAN Manager (NTLM), and other types of authentication.
                                                              //    INTERNET_FLAG_NEED_FILE               :Causes a temporary file to be created if the file cannot be cached.
                                                              //    INTERNET_FLAG_NO_AUTH                 :Does not attempt authentication automatically.
                                                              //    INTERNET_FLAG_NO_AUTO_REDIRECT        :Does not automatically handle redirection in HttpSendRequest.
                                                              //    INTERNET_FLAG_NO_CACHE_WRITE          :Does not add the returned entity to the cache.
                                                              //    INTERNET_FLAG_NO_COOKIES              :Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database.
                                                              //    INTERNET_FLAG_NO_UI                   :Disables the cookie dialog box.
                                                              //    INTERNET_FLAG_PASSIVE                 :Uses passive FTP semantics. InternetOpenUrl uses this flag for FTP files and directories.
                                                              //    INTERNET_FLAG_PRAGMA_NOCACHE          :Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
                                                              //    INTERNET_FLAG_RAW_DATA                :Returns the data as a GOPHER_FIND_DATA structure when retrieving Gopher directory information, or as a WIN32_FIND_DATA structure when retrieving FTP directory information. If this flag is not specified or if the call was made through a CERN proxy, InternetOpenUrl returns the HTML version of the directory.
                                                              //    INTERNET_FLAG_RELOAD                  :Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
                                                              //    INTERNET_FLAG_RESYNCHRONIZE           :Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded.
                                                              //    INTERNET_FLAG_SECURE                  :Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests.
                       dwContext: DWORD                       // Value that contains the application-defined value that is passed, along with the returned handle, to any callback functions.
                       ): HINTERNET;                          // Returns a valid handle to the FTP, Gopher, or HTTP URL if the connection is successfully established, or NULL if the connection fails. To retrieve a specific error message, call GetLastError.
                                                              //    To determine why access to the service was denied, call InternetGetLastResponseInfo.
begin
  result:=InternetOpenUrl(hInet, pchar(Url), pchar(Headers), length(Headers), dwFlags, dwContext);
end;
{***************************************** END OF "InternalInternetOpenUrl" *********************************************}


{  **** Reads data from a handle opened by the InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest function.}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetreadfile.asp                    }
function TINETApi_Intf.InternalInternetReadFile(
                       hFile: HINTERNET;                      // Valid HINTERNET handle returned from a previous call to InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest.
                       lpBuffer: Pointer;                     // Pointer to a buffer that receives the data to read.
                       dwNumberOfBytesToRead: DWORD;          // Value that contains the number of bytes to read.
                       var lpdwNumberOfBytesRead: DWORD       // A dword variable that receives the number of bytes read. InternetReadFile sets this value to zero before doing any work or error checking.
                       ): boolean;                            // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
                                                              //    An application can also use InternetGetLastResponseInfo when necessary.
begin
  result:=boolean(InternetReadFile(hFile, lpBuffer, dwNumberOfBytesToRead,lpdwNumberOfBytesRead));
end;
{***************************************** END OF "InternalInternetReadFile" *******************************************}


{  **** Sets a file position for InternetReadFile. This is a synchronous call; however, subsequent calls to
   **** InternetReadFile might block or return pending if the data is not available from the cache and the
   server does not support random access.                                                                               }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetfilepointer.asp             }

{  ***************************** IMPORTANT REMARKS OF USING THIS FUNCTION ********************************************

   !!!! This function cannot be used once the end of the file has been reached by InternetReadFile. !!!!

   For HINTERNET handles created by HttpOpenRequest and sent by HttpSendRequestEx, a call to HttpEndRequest must be
   made on the handle before InternetSetFilePointer is used.

   InternetSetFilePointer cannot be used reliably if the content length is unknown.                                     }
function TINETApi_Intf.InternalInternetSetFilePointer(
                       hFile: HINTERNET;                      // Valid HINTERNET handle returned from a previous call to InternetOpenUrl (on an HTTP or Secure Hypertext Transfer Protocol (HTTPS)URL) or
                                                              //    HttpOpenRequest (using the GET or HEAD HTTP verb and passed to HttpSendRequest or HttpSendRequestEx). This handle must not have been created with
                                                              //    the INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_NO_CACHE_WRITE value set.
                       lDistanceToMove: Longint;              // that specifies the number of bytes to move the file pointer. A positive value moves the pointer forward in the file; a negative value moves it backward.
                       pReserved: Pointer;                    // Reserved. Must be set to NULL.
                       dwMoveMethod: DWORD;                   // value that indicates the starting point for the file pointer move. This can be one of the following values.
                                                              //    FILE_BEGIN   : Starting point is zero or the beginning of the file. If FILE_BEGIN is specified, lDistanceToMove is interpreted as an unsigned location for the new file pointer.
                                                              //    FILE_CURRENT : Current value of the file pointer is the starting point.
                                                              //    FILE_END     : Current end-of-file position is the starting point. This method fails if the content length is unknown.
                       dwContext: DWORD                       // Reserved. Must be set to 0.
                       ): DWORD;                              // Returns the current file position if the function succeeds, or -1 otherwise.
begin
  result:=InternetSetFilePointer(hFile, lDistanceToMove, pReserved, dwMoveMethod, dwContext);
end;
{************************************** END OF "InternalInternetSetFilePointer" ****************************************}


{ **** Writes data to an open Internet file.                                                                            }
{ See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetwritefile.asp                   }
function TINETApi_Intf.InternalInternetWriteFile(
                      hFile: HINTERNET;                       // Valid HINTERNET handle returned from a previous call to FtpOpenFile or an HINTERNET handle sent by HttpSendRequestEx
                      lpBuffer: Pointer;                      // Pointer to a buffer that contains the data to be written to the file.
                      dwNumberOfBytesToWrite: DWORD;          // Unsigned long integer value that contains the number of bytes to write to the file.
                      var lpdwNumberOfBytesWritten: DWORD     // an unsigned long integer variable that receives the number of bytes written to the buffer.
                                                              //    InternetWriteFile sets this value to zero before doing any work or error checking.
                      ): boolean;                             // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                              //    To get extended error information, call GetLastError.
                                                              //    An application can also use InternetGetLastResponseInfo when necessary.

begin
  result:=boolean(InternetWriteFile(hFile, lpBuffer, dwNumberOfBytesToWrite, lpdwNumberOfBytesWritten));
end;
{***************************************** END OF "InternalInternetWriteFile" *****************************************}


{  **** Queries the server to determine the amount of data available.
       -------- IMPORTANT Remarks of Function -----------
       This function returns the number of bytes of data that are available to be read immediately by a subsequent
       call to InternetReadFile. If there is currently no data available and the end of the file has not been reached,
       the request waits until data becomes available. The amount of data remaining will not be recalculated until
       all available data indicated by the call to InternetQueryDataAvailable is read.

       For HINTERNET handles created by HttpOpenRequest and sent by HttpSendRequestEx,
       a call to HttpEndRequest must be made on the handle before InternetQueryDataAvailable can be used.               }

{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetquerydataavailable.asp         }
function TINETApi_Intf.InternalInternetQueryDataAvailable(
                      hFile: HINTERNET;                       // Valid HINTERNET handle, as returned by InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest.
                      var lpdwNumberOfBytesAvailable: DWORD;  // variable that receives the number of available bytes.
                      dwFlags: DWORD;                         // Reserved. Must be set to 0.
                      dwContext: DWORD                        // Reserved. Must be set to 0.
                      ): boolean;                             // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                              //    To get extended error information, call GetLastError.
                                                              //    If the function finds no matching files,
                                                              //    GetLastError returns ERROR_NO_MORE_FILES.
begin
  result:=boolean(InternetQueryDataAvailable(hFile, lpdwNumberOfBytesAvailable, dwFlags, dwContext));
end;
{************************************* END OF "InternalInternetQueryDataAvailable" *************************************}


{  **** Continues a file search started as a result of a previous call to FtpFindFirstFile or GopherFindFirstFile.      }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetfindnextfile.asp               }
function TINETApi_Intf.InternalInternetFindNextFile(
                      hFind: HINTERNET;                       // Valid HINTERNET handle returned from either FtpFindFirstFile or GopherFindFirstFile,
                                                              //    or from InternetOpenUrl (directories only).
                      lpvFindData: Pointer                    // [out] Pointer to the buffer that receives information about the found file or directory.
                                                              //     The format of the information placed in the buffer depends on the protocol in use.
                                                              //     The FTP protocol returns a WIN32_FIND_DATA structure, and the Gopher protocol returns a GOPHER_FIND_DATA structure.
                      ): boolean;                             // Returns TRUE if the function succeeds, or FALSE otherwise.
                                                              //     To get extended error information, call GetLastError.
                                                              //     If the function finds no matching files, GetLastError returns ERROR_NO_MORE_FILES.
begin
  result:=boolean(InternetFindNextFile(hFind, lpvFindData));
end;
{**************************************** END OF "InternalInternetFindNextFile" ****************************************}


{  **** Queries an Internet option on the specified handle.
       -------- IMPORTANT Remarks of Function -----------
      GetLastError will return the ERROR_INVALID_PARAMETER if an option flag that is invalid for the specified handle type is passed to the dwOption parameter.
      For more detailed information on how to query Microsoft® Win32® Internet (WinInet) options
      see "Setting and Retrieving Internet Options" <http://msdn.microsoft.com/workshop/networking/wininet/tutorials/options.asp>.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetqueryoption.asp                }
function TINETApi_Intf.InternalInternetQueryOption(
                      hInet: HINTERNET;                       // HINTERNET handle on which to query information.
                      dwOption: DWORD;                        // value that contains the Internet option to query.
                                                              //    This can be one of the "Option Flags" <http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/wininet/reference/constants/flags.asp> values
                      lpBuffer: Pointer;                      // [out] Pointer to a buffer that receives the option setting.
                                                              //    Strings returned by InternetQueryOption are globally allocated,
                                                              //    so the calling application must globally free the string when it is finished using it.
                      var lpdwBufferLength: DWORD             // [in, out] Pointer to an unsigned long integer variable that contains the length of lpBuffer.
                                                              //    If lpBuffer contains a string, lpdwBufferLength points to the length of lpBuffer in bytes.
                                                              //    If lpBuffer contains anything other than a string, lpdwBufferLength points to the length of lpBuffer in BYTEs.
                                                              //    When InternetQueryOption returns, lpdwBufferLength points to the length of the data placed into lpBuffer.
                                                              //    If GetLastError returns ERROR_INSUFFICIENT_BUFFER, this parameter points to the number of bytes required to hold the requested information.
                      ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.
begin
  result:=boolean(InternetQueryOption(hInet, dwOption, lpBuffer, lpdwBufferLength));
end;
{***************************************** END OF "InternalInternetQueryOption" *****************************************}


{  **** Sets an Internet option.
       -------- IMPORTANT Remarks of Function -----------
      GetLastError will return the ERROR_INVALID_PARAMETER if an option flag that is invalid for the specified handle type is passed to the dwOption parameter.
      For more detailed information on how to query Microsoft® Win32® Internet (WinInet) options
      see "Setting and Retrieving Internet Options" <http://msdn.microsoft.com/workshop/networking/wininet/tutorials/options.asp>.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetoption.asp                   }
function TINETApi_Intf.InternalInternetSetOption(
                      hInet: HINTERNET;                       //  HINTERNET handle on which to set information.
                      dwOption: DWORD;                        // value that contains the Internet option to query.
                                                              //    This can be one of the "Option Flags" <http://msdn.microsoft.com/library/default.asp?url=/workshop/networking/wininet/reference/constants/flags.asp> values
                      lpBuffer: Pointer;                      // [in] Pointer to a buffer that contains the option setting.
                      dwBufferLength: DWORD                   // [in] Unsigned long integer value that contains the length of the lpBuffer buffer.
                                                              //    If lpBuffer contains a string, dwBufferLength is the length of lpBuffer in TCHARs.
                                                              //    If lpBuffer contains anything other than a string, dwBufferLength is the length of lpBuffer in BYTEs.
                                                              //    When lpBuffer represents a BOOL or a DWORD, dwBufferLength should be set to 4 BYTEs.
                      ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.
begin
  result:=boolean(InternetSetOption(hInet, dwOption, lpBuffer, dwBufferLength));
end;
{******************************************* END OF "InternalInternetSetOption" *****************************************}


{  **** Allows the user to place a lock on the file that is being used.
       -------- IMPORTANT Remarks of Function -----------
       If the HINTERNET handle passed to hInternet was created using INTERNET_FLAG_NO_CACHE_WRITE or
       INTERNET_FLAG_DONT_CACHE, the function creates a temporary file with the extension .tmp,
       unless it is an HTTPS resource. If the handle was created using INTERNET_FLAG_NO_CACHE_WRITE or
       INTERNET_FLAG_DONT_CACHE and it is accessing an HTTPS resource, InternetLockRequestFile fails.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetlockrequestfile.asp             }
function TINETApi_Intf.InternalInternetLockRequestFile(
                      hInternet: HINTERNET;                   // HINTERNET handle returned by FtpOpenFile, GopherOpenFile, HttpOpenRequest, or InternetOpenUrl.
                      var lphLockRequestInfo: THandle         // [out] Pointer to a handle to store the lock request handle
                      ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.
begin
  result:=boolean(InternetLockRequestFile(hInternet, @lphLockRequestInfo));
end;
{**************************************** END OF "InternalInternetLockRequestFile" *************************************}


{  **** Unlocks a file that was locked using InternetLockRequestFile.                                                   }
{  See http://msdn.microsoft.com/library/networking/wininet/reference/functions/internetunlockrequestfile.asp           }
function TINETApi_Intf.InternalInternetUnlockRequestFile(
                      hLockRequestInfo: THANDLE               // Lock request handle that was returned by InternetLockRequestFile.
                      ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError.
begin
  result:=boolean(InternetUnlockRequestFile(hLockRequestInfo));
end;
{*************************************** END OF "InternalInternetUnlockRequestFile" ************************************}


{  **** Sets up a callback function that Microsoft® Win32® Internet functions can call as progress is made during an operation.
       -------- IMPORTANT Remarks of Function -----------
       Both synchronous and asynchronous functions use the callback function to indicate the progress of the request,
       such as resolving a name, connecting to a server, and so on. The callback function is required for an asynchronous operation.
       The asynchronous request will call back to the application with INTERNET_STATUS_REQUEST_COMPLETE to indicate the request has been completed.
       A callback function can be set on any handle, and is inherited by derived handles. A callback function can be changed using
       InternetSetStatusCallback, providing there are no pending requests that need to use the previous callback value.
       Note, however, that changing the callback function on a handle does not change the callbacks on derived handles,
       such as that returned by InternetConnect. You must change the callback function at each level.
       Many of the Win32 Internet functions perform several operations on the network.
       Each operation can take time to complete, and each can fail.
       It is sometimes desirable to display status information during a long-term operation.
       You can display status information by setting up an Internet status callback function that cannot be removed as long as
       any callbacks or any asynchronous functions are pending.
       After initiating InternetSetStatusCallback, the callback function can be accessed from within any Win32 Internet function
       for monitoring time-intensive network operations.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetsetstatuscallback.asp          }
function TINETApi_Intf.InternalInternetSetStatusCallback(
              hInet: HINTERNET;                               // HINTERNET handle for which the callback is to be set.
              lpfnInternetCallback: PFNInternetStatusCallback // Pointer to the callback function to call when progress is made,
                                                              //     or to return NULL to remove the existing callback function.
                                                              //  For more information about the callback function,
                                                              //  see "INTERNET_STATUS_CALLBACK" <http://msdn.microsoft.com/workshop/networking/wininet/reference/prototypes/internet_status_callback.asp>.
              ): PFNInternetStatusCallback;                   //  Returns the previously defined status callback function if successful,
                                                              //     NULL if there was no previously defined status callback function,
                                                              //     or INTERNET_INVALID_STATUS_CALLBACK if the callback function is not valid.
begin
  result:=InternetSetStatusCallback(hInet, lpfnInternetCallback);
end;
{*************************************** END OF "InternalInternetSetStatusCallback" ************************************}


{  Prototype for an application-defined status callback function.
       -------- IMPORTANT Remarks of Function -----------
       Because callbacks are made during processing of the request,
       the application should spend as little time as possible in the callback function to avoid degrading data throughput on the network.
       For example, displaying a dialog box in a callback function can be such a lengthy operation that the server terminates the request.
       The callback function can be called in a thread context different from the thread that initiated the request.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/prototypes/internet_status_callback.asp }
procedure TINETApi_Intf.doOnCallback(
      hInet:HINTERNET;                      // Handle for which the callback function is being called.
      dwContext:DWORD;                      // Pointer to an unsigned long integer value that contains
                                            //   the application-defined context value associated with hInternet.
      dwInternetStatus:DWORD;               // Unsigned long integer value that contains the status code that indicates
                                            //    why the callback function is being called. This can be one of the following values:
                                            //    INTERNET_STATUS_CLOSING_CONNECTION   : Closing the connection to the server. The lpvStatusInformation parameter is NULL.
                                            //    INTERNET_STATUS_CONNECTED_TO_SERVER  : Successfully connected to the socket address (SOCKADDR) pointed to by lpvStatusInformation
                                            //    INTERNET_STATUS_CONNECTING_TO_SERVER : Connecting to the socket address (SOCKADDR) pointed to by lpvStatusInformation.
                                            //    INTERNET_STATUS_CONNECTION_CLOSED    : Successfully closed the connection to the server. The lpvStatusInformation parameter is NULL.
                                            //    INTERNET_STATUS_CTL_RESPONSE_RECEIVED: Not implemented.
                                            //    INTERNET_STATUS_DETECTING_PROXY      : Notifies the client application that a proxy has been detected.
                                            //    INTERNET_STATUS_HANDLE_CLOSING       : This handle value has been terminated.
                                            //    INTERNET_STATUS_HANDLE_CREATED       : Used by InternetConnect to indicate it has created the new handle. This lets the application call InternetCloseHandle from another thread, if the connect is taking too long. The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
                                            //    INTERNET_STATUS_INTERMEDIATE_RESPONSE: Received an intermediate (100 level) status code message from the server.
                                            //    INTERNET_STATUS_NAME_RESOLVED        : Successfully found the IP address of the name contained in lpvStatusInformation
                                            //    INTERNET_STATUS_PREFETCH             : Not implemented.
                                            //    INTERNET_STATUS_RECEIVING_RESPONSE   : Waiting for the server to respond to a request. The lpvStatusInformation parameter is NULL.
                                            //    INTERNET_STATUS_REDIRECT             : An HTTP request is about to automatically redirect the request. The lpvStatusInformation parameter points to the new URL. At this point, the application can read any data returned by the server with the redirect response and can query the response headers. It can also cancel the operation by closing the handle. This callback is not made if the original request specified INTERNET_FLAG_NO_AUTO_REDIRECT.
                                            //    INTERNET_STATUS_REQUEST_COMPLETE     : An asynchronous operation has been completed. The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
                                            //    INTERNET_STATUS_REQUEST_SENT         : Successfully sent the information request to the server. The lpvStatusInformation parameter points to a DWORD containing the number of bytes sent.
                                            //    INTERNET_STATUS_RESOLVING_NAME       : Looking up the IP address of the name contained in lpvStatusInformation
                                            //    INTERNET_STATUS_RESPONSE_RECEIVED    : Successfully received a response from the server. The lpvStatusInformation parameter points to a DWORD containing the number of bytes received.
                                            //    INTERNET_STATUS_SENDING_REQUEST      : Sending the information request to the server. The lpvStatusInformation parameter is NULL.
                                            //    INTERNET_STATUS_STATE_CHANGE         : Moved between a secure (HTTPS) and a nonsecure (HTTP) site.
      lpvStatusInformation:pointer;         // Pointer to a buffer that contains information pertinent to this call to the callback function.
      dwStatusInformationLength:DWORD       // Unsigned long integer value that contains the size, in TCHARs, of the lpvStatusInformation buffer.
      );                                    // Void function so No return value.
begin
  if assigned(fCallbackEvent) then
    fCallbackEvent(hInet, dwContext, dwInternetStatus, lpvStatusInformation, dwStatusInformationLength);
end;
{************************************************* END OF "doOnCallback" ***********************************************}


{  **** Retrieves the last Microsoft® Win32® Internet function error description or server response on the thread calling this function.
      -------- IMPORTANT Remarks of Function -----------
      The FTP and Gopher protocols can return additional text information along with most errors.
      This extended error information can be retrieved by using the InternetGetLastResponseInfo function whenever
      GetLastError returns ERROR_INTERNET_EXTENDED_ERROR (occurring after an unsuccessful function call).
      The buffer pointed to by lpszBuffer must be large enough to hold both the error string and a zero terminator at the end of the string.
      However, note that the value returned in lpdwBufferLength does not include the terminating zero.

      InternetGetLastResponseInfo can be called multiple times until another Win32 Internet function is called on this thread.
      When another function is called, the internal buffer that is storing the last response information is cleared.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/internetgetlastresponseinfo.asp        }
function TINETApi_Intf.InternalInternetGetLastResponseInfo(
                       var lpdwError: DWORD;                  // [out] Pointer to an unsigned long integer variable that receives
                                                              //       an error message pertaining to the operation that failed.
                       var Buffer: string                     // [out] a buffer that receives the error text.
                       ): boolean;                            // Returns TRUE if error text was successfully written to the buffer, or FALSE otherwise.
                                                              //   To get extended error information, call GetLastError.
                                                              //   If the buffer is too small to hold all the error text,
                                                              //   GetLastError returns ERROR_INSUFFICIENT_BUFFER, and the lpdwBufferLength parameter contains
var                                                           //   the minimum buffer size required to return all the error text.
  pBuffer:pchar;
  lpdwBufferLength:dword;
begin
  lpdwBufferLength:=1024;
  getMem(pBuffer,lpdwBufferLength);
  result:=boolean(InternetGetLastResponseInfo(lpdwError,pBuffer, lpdwBufferLength));
  buffer := string(pBuffer);
  freeMem(pBuffer);

end;
{************************************* END OF "InternalInternetGetLastResponseInfo" ************************************}


{-----------------------------------------------------------------------------------------------------------------------}
{----------------------------------------- HTTP API FUNCTION BROKERS ---------------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}


{  **** Creates an HTTP request handle.
      -------- IMPORTANT Remarks of Function -----------
      HttpOpenRequest creates a new HTTP request handle and stores the specified parameters in that handle.
      An HTTP request handle holds a request to be sent to an HTTP server and contains all RFC822/MIME/HTTP headers
      to be sent as part of the request. Beginning with Microsoft Internet Explorer 5, if Verb is set to "HEAD",
      the Content-Length header is ignored on responses from HTTP/1.1 servers. After the calling application has
      finished using the HINTERNET handle returned by HttpOpenRequest,
      it must be closed using the InternalInternetCloseHandle function.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpopenrequest.asp                    }
function TINETApi_Intf.InternalHttpOpenRequest(
           hConnect: HINTERNET;                   // HINTERNET handle to an HTTP session returned by InternalInternetConnect.
           Verb: string;                          // A string that contains the HTTP verb (valid values 'GET', 'PUT', 'POST, 'HEAD') to use in the request.
                                                  //    If this parameter is NULL, the function uses GET as the HTTP verb.
           ObjectName: string;                    // A string that contains the name of the target object of the specified HTTP verb.
                                                  //    This is generally a file name, an executable module, or a search specifier.
           Version: string;                       // A string that contains the HTTP version. If this parameter is NULL, the function uses HTTP/1.0 as the version.
           Referrer: string;                      // A string that specifies the URL of the document from which the URL in the request (lpszObjectName) was obtained.
                                                  //    If this parameter is NULL, no "referrer" is specified.
           AcceptTypes: TStrings;                // Address of a null-terminated array of string pointers indicating media types accepted by the client.
                                                  //    If this parameter is NULL, no types are accepted by the client.
                                                  //    Servers generally interpret a lack of accept types to indicate that the client accepts only
                                                  //    documents of type "text/*" (that is, only text documents—no pictures or other binary files).
                                                  //    For a list of valid media types, see "Media Types" at ftp://ftp.isi.edu/in-notes/iana/assignments/media-types/media-types .
           dwFlags: DWORD;                        // Unsigned long integer value that contains the Internet flag values. This can be any of the following values:
                                                  //    INTERNET_FLAG_CACHE_IF_NET_FAIL : Returns the resource from the cache if the network request for the resource fails due to an ERROR_INTERNET_CONNECTION_RESET (the connection with the server has been reset) or ERROR_INTERNET_CANNOT_CONNECT (the attempt to connect to the server failed).
                                                  //    INTERNET_FLAG_HYPERLINK         : Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
                                                  //    INTERNET_FLAG_IGNORE_CERT_CN_INVALID   : Disables Microsoft® Win32® Internet function checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. Win32 Internet functions use a simple check against certificates by comparing for matching host names and simple wildcarding rules.
                                                  //    INTERNET_FLAG_IGNORE_CERT_DATE_INVALID : Disables Win32 Internet function checking of SSL/PCT-based certificates for proper validity dates.
                                                  //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  : Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTPS to HTTP URLs.
                                                  //    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS : Disables the ability of the Win32 Internet functions to detect this special type of redirect. When this flag is used, Win32 Internet functions transparently allow redirects from HTTP to HTTPS URLs.
                                                  //    INTERNET_FLAG_KEEP_CONNECTION          : Uses keep-alive semantics, if available, for the connection. This flag is required for Microsoft Network (MSN), NT LAN Manager (NTLM), and other types of authentication
                                                  //    INTERNET_FLAG_NEED_FILE                : Causes a temporary file to be created if the file cannot be cached.
                                                  //    INTERNET_FLAG_NO_AUTH                  : Does not attempt authentication automatically.
                                                  //    INTERNET_FLAG_NO_AUTO_REDIRECT         : Does not automatically handle redirection in InternalHttpSendRequest.
                                                  //    INTERNET_FLAG_NO_CACHE_WRITE           : Does not add the returned entity to the cache.
                                                  //    INTERNET_FLAG_NO_COOKIES               : Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database.
                                                  //    INTERNET_FLAG_NO_UI                    : Disables the cookie dialog box.
                                                  //    INTERNET_FLAG_PRAGMA_NOCACHE           : Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
                                                  //    INTERNET_FLAG_RELOAD                   : Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
                                                  //    INTERNET_FLAG_RESYNCHRONIZE            : Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded.
                                                  //    INTERNET_FLAG_SECURE                   : Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests.
           dwContext: DWORD
           ): HINTERNET;
var
  pAcceptTypes:PLPSTR;
  a:array[0..4096] of pchar;
  i:integer;
begin
  if not assigned(AcceptTypes) then
    raise Exception.Create(sExceptionAcceptTypesNotAssigned);
  if AcceptTypes.Count=0 then
    AcceptTypes.Add('text/*');
  for i:=0 to AcceptTypes.Count-1 do
  begin
    a[i]:=pchar(AcceptTypes[i]);
  end;
  a[AcceptTypes.Count]:=nil;
  pAcceptTypes:=@a;
  result := HttpOpenRequest(hConnect, pchar(Verb), pchar(ObjectName), pchar(Version), pchar(Referrer),pAcceptTypes, dwFlags, dwContext);
  if assigned(result) then  // Register a callback
  begin
//    RegisterCallback(result,doOnCallback);
  end;

end;
{****************************************** END OF "InternalHttpOpenRequest" *******************************************}

{  **** Adds one or more HTTP request headers to the HTTP request handle.
      -------- IMPORTANT Remarks of Function -----------
      HttpAddRequestHeaders appends additional, free-format headers to the HTTP request handle and
      is intended for use by sophisticated clients that need detailed control over the exact request
      sent to the HTTP server. Note that for basic HttpAddRequestHeaders, the application can pass
      in multiple headers in a single buffer. If the application is trying to remove or replace a header,
      only one header can be supplied in lpszHeaders.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpaddrequestheaders.asp              }
function TINETApi_Intf.InternalHttpAddRequestHeaders(
           hRequest: HINTERNET;                   // HINTERNET handle returned by a call to the HttpOpenRequest function.
           Headers: string;                       // A string variable containing the headers to append to the request.
                                                  //   Each header must be terminated by a CR/LF (carriage return/line feed) pair.
           dwModifiers: DWORD                     // Unsigned long integer value that contains the flags used to modify the semantics of this function.
                                                  //   Can be a combination of the following values:
                                                  //   HTTP_ADDREQ_FLAG_ADD        : Adds the header if it does not exist. Used with HTTP_ADDREQ_FLAG_REPLACE.
                                                  //   HTTP_ADDREQ_FLAG_ADD_IF_NEW : Adds the header only if it does not already exist; otherwise, an error is returned.
                                                  //   HTTP_ADDREQ_FLAG_COALESCE   : Coalesces headers of the same name.
                                                  //   HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA     : Coalesces headers of the same name. For example, adding "Accept: text/*" followed by "Accept: audio/*" with this flag results in the formation of the single header "Accept: text/*, audio/*". This causes the first header found to be coalesced. It is up to the calling application to ensure a cohesive scheme with respect to coalesced/separate headers.
                                                  //   HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON : Coalesces headers of the same name using a semicolon.
                                                  //   HTTP_ADDREQ_FLAG_REPLACE   : Replaces or removes a header. If the header value is empty and the header is found, it is removed. If not empty, the header value is replaced.
           ): boolean;                            // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
begin
  result := boolean(HttpAddRequestHeaders(hRequest, pchar(Headers), length(Headers), dwModifiers));
end;
{*************************************** END OF "InternalHttpAddRequestHeaders" ****************************************}


{  **** Sends the specified request to the HTTP server.
      -------- IMPORTANT Remarks of Function -----------
      HttpSendRequest sends the specified request to the HTTP server and allows the client to
      specify additional headers to send along with the request.The function also lets the client specify
      optional data to send to the HTTP server immediately following the request headers.
      This feature is generally used for "write" operations such as PUT and POST. After the request is sent,
      the status code and response headers from the HTTP server are read. These headers are maintained internally and
      are available to client applications through the InternalHttpQueryInfo function.
      An application can use the same HTTP request handle in multiple calls to HttpSendRequest,
      but the application must read all data returned from the previous call before calling the function again.
      In offline mode, HttpSendRequest returns ERROR_FILE_NOT_FOUND if the resource is not found in the Internet cache.
      There two versions of HttpSendRequest — HttpSendRequestA (used with ANSI builds) and HttpSendRequestW (used with Unicode builds).
      If dwHeadersLength is -1L and lpszHeaders is not NULL, the following will happen:
         If HttpSendRequestA is called, the function assumes that lpszHeaders is zero-terminated (ASCIIZ), and the length is calculated.
         If HttpSendRequestW is called, the function fails with ERROR_INVALID_PARAMETER.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpsendrequest.asp                    }
function TINETApi_Intf.InternalHttpSendRequest(
           hRequest: HINTERNET;                    // HINTERNET handle returned by HttpOpenRequest
           pHeaders: pchar;                         // a buffer variable that contains the additional headers to be appended to the request.
                                                       //    This parameter can be NULL if there are no additional headers to append
           dwHeadersLength: dword;                 // length of buffer
           lpOptional: Pointer;                    // Pointer to a buffer containing any optional data to send immediately after the request headers.
                                                   //    This parameter is generally used for POST and PUT operations.
                                                   //    The optional data can be the resource or information being posted to the server.
                                                   //    This parameter can be NULL if there is no optional data to send.
           dwOptionalLength: DWORD                 // Unsigned long integer value that contains the length, in bytes, of the optional data.
                                                   //    This parameter can be zero if there is no optional data to send.
           ): boolean;                              // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
//var
 //pHeaders:pchar;
 //dwHeadersLength:dword;
begin
  {if Headers<>'' then
  begin
    pHeaders:=pchar(Headers);
    //dwHeadersLength:=length(Headers)+1
    dwHeadersLength:=0;
  end
  else
  begin
    pHeaders:=nil;
    dwHeadersLength:=0;
  end;
  }
  result := boolean(HttpSendRequest(hRequest, pHeaders, dwHeadersLength , lpOptional, dwOptionalLength));
end;
{****************************************** END OF "InternalHttpSendRequest" *******************************************}


{  **** Sends the specified request to the HTTP server.                                                                 }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpsendrequestex.asp                  }
function TINETApi_Intf.InternalHttpSendRequestEx(
           hRequest: HINTERNET;                    // HINTERNET handle returned by HttpOpenRequest.
           lpBuffersIn: PInternetBuffers;          // [in] Optional. Pointer to an INTERNET_BUFFERS (see <http://msdn.microsoft.com/workshop/networking/wininet/reference/structures/internet_buffers.asp>) structure.
           lpBuffersOut: PInternetBuffers;         // [out] Optional. Pointer to an INTERNET_BUFFERS structure
           dwFlags: DWORD;                         // [in] One of the following values:
                                                   //    HSR_ASYNC       : Forces asynchronous operations.
                                                   //    HSR_SYNC        : Forces synchronous operations.
                                                   //    HSR_USE_CONTEXT : Forces HttpSendRequestEx to use the context value, even if it is set to zero.
                                                   //    HSR_INITIATE    : Iterative operation (completed by HttpEndRequest).
                                                   //    HSR_DOWNLOAD    : Download resource to file.
                                                   //    HSR_CHUNKED     : Not implemented.
           dwContext: DWORD                        // [in] Unsigned long integer variable that contains the application-defined context value, if a status callback function has been registered.
           ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
begin
  result := boolean(HttpSendRequestEx(hRequest, lpBuffersIn, lpBuffersOut, dwFlags, dwContext));
end;
{***************************************** END OF "InternalHttpSendRequestEx" ******************************************}

{  **** Ends an HTTP request that was initiated by HttpSendRequestEx.
      -------- IMPORTANT Remarks of Function -----------
      If lpBuffersOut is not set to NULL, HttpEndRequest will return ERROR_INVALID_PARAMETER.                           }
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpendrequest.asp                     }
function TINETApi_Intf.InternalHttpEndRequest(
           hRequest: HINTERNET;                    // [in] HINTERNET handle returned by HttpOpenRequest and sent by HttpSendRequestEx.
           lpBuffersOut: PInternetBuffers;         // [out] Reserved. Must be set to NULL.
           dwFlags: DWORD;                         // [in] Unsigned long integer value that contains the flags that control this function. Can be one of the following values.
                                                   //    HSR_ASYNC       : Forces asynchronous operations.
                                                   //    HSR_SYNC        : Forces synchronous operations.
                                                   //    HSR_USE_CONTEXT : Forces HttpSendRequestEx to use the context value, even if it is set to zero.
                                                   //    HSR_INITIATE    : Iterative operation (completed by HttpEndRequest).
                                                   //    HSR_DOWNLOAD    : Download resource to file.
                                                   //    HSR_CHUNKED     : Not implemented.
           dwContext: DWORD                        // [in] Unsigned long integer variable that contains the application-defined context value, if a status callback function has been registered.
           ): boolean;                             // Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError.
begin
  result := boolean(HttpEndRequest(hRequest, lpBuffersOut, dwFlags, dwContext));
end;
{****************************************** END OF "InternalHttpEndRequest" ********************************************}


{  **** Retrieves header information associated with an HTTP request.
      -------- IMPORTANT Remarks of Function -----------
      You can retrieve the following types of data from HttpQueryInfo.
        * Strings (default)
        * SYSTEMTIME (for Data: Expires:, headers)
        * DWORD (for STATUS_CODE, CONTENT_LENGTH, and so on, if HTTP_QUERY_FLAG_NUMBER has been used)
     If your application requires that the data be returned as a data type other than a string,
     you must include the appropriate modifier with the attribute passed to dwInfoLevel.
     HttpQueryInfo is available in Microsoft® Internet Explorer 3.0 for the ANSI character set and
     in Internet Explorer 4.0 or later for ANSI and Unicode characters
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/httpqueryinfo.asp                      }
{---------------------------------------- Query Info Flags -------------------------------------------------------------}
{
  HTTP_QUERY_ACCEPT (24)                   : Retrieves the acceptable media types for the response.
  HTTP_QUERY_ACCEPT_CHARSET (25)           : Retrieves the acceptable character sets for the response.
  HTTP_QUERY_ACCEPT_ENCODING (26)          : Retrieves the acceptable content-coding values for the response.
  HTTP_QUERY_ACCEPT_LANGUAGE (27)          : Retrieves the acceptable natural languages for the response.
  HTTP_QUERY_ACCEPT_RANGES (42)            : Retrieves the types of range requests that are accepted for a resource.
  HTTP_QUERY_AGE (48)                      : Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
  HTTP_QUERY_ALLOW (7)                     : Receives the HTTP verbs supported by the server.
  HTTP_QUERY_AUTHORIZATION (28)            : Retrieves the authorization credentials used for a request.
  HTTP_QUERY_CACHE_CONTROL (49)            : Retrieves the cache control directives.
  HTTP_QUERY_CONNECTION (23)               : Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
  HTTP_QUERY_CONTENT_BASE (50)             : Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
  HTTP_QUERY_CONTENT_DESCRIPTION (4)       : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_CONTENT_DISPOSITION (47)      : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_CONTENT_ENCODING (29)         : Retrieves any additional content codings that have been applied to the entire resource.
  HTTP_QUERY_CONTENT_ID (3)                : Retrieves the content identification.
  HTTP_QUERY_CONTENT_LANGUAGE (6)          : Retrieves the language that the content is in.
  HTTP_QUERY_CONTENT_LENGTH (5)            : Retrieves the size of the resource, in bytes.
  HTTP_QUERY_CONTENT_LOCATION (51)         : Retrieves the resource location for the entity enclosed in the message.
  HTTP_QUERY_CONTENT_MD5 (52)              : Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
  HTTP_QUERY_CONTENT_RANGE (53)            : Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
  HTTP_QUERY_CONTENT_TRANSFER_ENCODING (2) : Receives the additional content coding that has been applied to the resource.
  HTTP_QUERY_CONTENT_TYPE (1)              : Receives the content type of the resource (such as text/html).
  HTTP_QUERY_COOKIE (44)                   : Retrieves any cookies associated with the request.
  HTTP_QUERY_COST (15)                     : No longer supported.
  HTTP_QUERY_CUSTOM (65535)                : Causes HttpQueryInfo to search for the header name specified in lpvBuffer and store the header information in lpvBuffer.
  HTTP_QUERY_DATE (9)                      : Receives the date and time at which the message was originated.
  HTTP_QUERY_DERIVED_FROM (14)             : No longer supported.
  HTTP_QUERY_ECHO_HEADERS (73)             : Not currently implemented.
  HTTP_QUERY_ECHO_HEADERS_CRLF (74)        : Not currently implemented.
  HTTP_QUERY_ECHO_REPLY (72)               : Not currently implemented.
  HTTP_QUERY_ECHO_REQUEST (71)             : Not currently implemented.
  HTTP_QUERY_ETAG (54)                     : Retrieves the entity tag for the associated entity.
  HTTP_QUERY_EXPECT (68)                   : Retrieves the Expect header, which indicates whether the client application should expect 100 series responses.
  HTTP_QUERY_EXPIRES (10)                  : Receives the date and time after which the resource should be considered outdated.
  HTTP_QUERY_FORWARDED (30)                : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_FROM (31)                     : Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
  HTTP_QUERY_HOST (55)                     : Retrieves the Internet host and port number of the resource being requested.
  HTTP_QUERY_IF_MATCH (56)                 : Retrieves the contents of the If-Match request-header field.
  HTTP_QUERY_IF_MODIFIED_SINCE (32)        : Retrieves the contents of the If-Modified-Since header.
  HTTP_QUERY_IF_NONE_MATCH (57)            : Retrieves the contents of the If-None-Match request-header field.
  HTTP_QUERY_IF_RANGE (58)                 : Retrieves the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
  HTTP_QUERY_IF_UNMODIFIED_SINCE (59)      : Retrieves the contents of the If-Unmodified-Since request-header field.
  HTTP_QUERY_LAST_MODIFIED (11)            : Receives the date and time at which the server believes the resource was last modified.
  HTTP_QUERY_LINK (16)                     : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_LOCATION (33)                 : Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
  HTTP_QUERY_MAX (75)                      : Not a query flag. Indicates the maximum value of an HTTP_QUERY_* value.
  HTTP_QUERY_MAX_FORWARDS (60)             : Retrieves the number of proxies or gateways that can forward the request to the next inbound server.
  HTTP_QUERY_MESSAGE_ID (12)               : No longer supported.
  HTTP_QUERY_MIME_VERSION (0)              : Receives the version of the MIME protocol that was used to construct the message.
  HTTP_QUERY_ORIG_URI (34)                 : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_PRAGMA (17)                   : Receives the implementation-specific directives that might apply to any recipient along the request/response chain.
  HTTP_QUERY_PROXY_AUTHENTICATE (41)       : Retrieves the authentication scheme and realm returned by the proxy.
  HTTP_QUERY_PROXY_AUTHORIZATION (61)      : Retrieves the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
  HTTP_QUERY_PROXY_CONNECTION (69)         : Retrieves the Proxy-Connection header.
  HTTP_QUERY_PUBLIC (8)                    : Receives methods available at this server.
  HTTP_QUERY_RANGE (62)                    : Retrieves the byte range of an entity.
  HTTP_QUERY_RAW_HEADERS (21)              : Receives all the headers returned by the server. Each header is terminated by "\0". An additional "\0" terminates the list of headers.
  HTTP_QUERY_RAW_HEADERS_CRLF (22)         : Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
  HTTP_QUERY_REFERER (35)                  : Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
  HTTP_QUERY_REFRESH (46)                  : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_REQUEST_METHOD (45)           : Receives the HTTP verb that is being used in the request, typically GET or POST.
  HTTP_QUERY_RETRY_AFTER (36)              : Retrieves the amount of time the service is expected to be unavailable.
  HTTP_QUERY_SERVER (37)                   : Retrieves information about the software used by the origin server to handle the request.
  HTTP_QUERY_SET_COOKIE (43)               : Receives the value of the cookie set for the request.
  HTTP_QUERY_STATUS_CODE (19)              : Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
  HTTP_QUERY_STATUS_TEXT (20)              : Receives any additional text returned by the server on the response line.
  HTTP_QUERY_TITLE (38)                    : Obsolete. Maintained for legacy application compatibility only.
  HTTP_QUERY_TRANSFER_ENCODING (63)        : Retrieves the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
  HTTP_QUERY_UNLESS_MODIFIED_SINCE (70)    : Retrieves the Unless-Modified-Since header.
  HTTP_QUERY_UPGRADE (64)                  : Retrieves the additional communication protocols that are supported by the server.
  HTTP_QUERY_URI (13)                      : Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.
  HTTP_QUERY_USER_AGENT (39)               : Retrieves information about the user agent that made the request.
  HTTP_QUERY_VARY (65)                     : Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
  HTTP_QUERY_VERSION (18)                  : Receives the last response code returned by the server.
  HTTP_QUERY_VIA (66)                      : Retrieves the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
  HTTP_QUERY_WARNING (67)                  : Retrieves additional information about the status of a response that might not be reflected by the response status code.
  HTTP_QUERY_WWW_AUTHENTICATE (40)         : Retrieves the authentication scheme and realm returned by the server.
}
function TINETApi_Intf.InternalHttpQueryInfo(
           hRequest: HINTERNET;                    // [in] HINTERNET request handle returned by InternalHttpOpenRequest or InternalInternetOpenUrl.
           dwInfoLevel: DWORD;                     // [in] Unsigned long integer value that contains a combination of an attribute to retrieve and the flags that modify the request. For a list of possible attribute and modifier values,
                                                   //    see Query Info Flags above or at <http://msdn.microsoft.com/workshop/networking/wininet/reference/constants/queryinfo_flags.asp>.
           var Buffer: string;                     // [in] A String buffer that receives the information.
           var lpdwIndex: DWORD                    // [in, out] Pointer to a zero-based header index used to enumerate multiple headers with
                                                   //      the same name. When calling the function, this parameter is the index of
                                                   //      the specified header to return. When the function returns, this parameter is
                                                   //      the index of the next header.
                                                   //      If the next index cannot be found, ERROR_HTTP_HEADER_NOT_FOUND is returned.

           ): boolean;
var
  lpvBuffer:pchar;
  lpdwBufferLength: DWORD;           // [in] Pointer to a value that contains the length of the data buffer, in bytes.
                                     //    When the function returns, this parameter contains the address of a value specifying
                                     //    the length of the information written to the buffer.
                                     //    When the function returns strings, the following rules apply.
                                     //    * If the function succeeds, lpdwBufferLength specifies the length of the string,
                                     //      in BYTEs, minus 1 for the terminating NULL.
                                     //    * If the function fails and ERROR_INSUFFICIENT_BUFFER is returned,
                                     //      lpdwBufferLength specifies the number of bytes that the application must allocate
                                     //      to receive the string.

begin
  lpdwBufferLength:=4096;
  getMem(lpvBuffer, lpdwBufferLength);
  try
    result:=boolean(HttpQueryInfo(hRequest, dwInfoLevel, lpvBuffer, lpdwBufferLength, lpdwIndex));
    if result then
       buffer:=string(lpvBuffer);
  finally
    freeMem(lpvBuffer, lpdwBufferLength);
  end;
end;
function TINETApi_Intf.InternalHttpQueryInfoAsInt(
           hRequest: HINTERNET;                    // [in] HINTERNET request handle returned by InternalHttpOpenRequest or InternalInternetOpenUrl.
           dwInfoLevel: DWORD;                     // [in] Unsigned long integer value that contains a combination of an attribute to retrieve and the flags that modify the request. For a list of possible attribute and modifier values,
                                                   //    see Query Info Flags above or at <http://msdn.microsoft.com/workshop/networking/wininet/reference/constants/queryinfo_flags.asp>.
           var Buffer: dword;                      // [in] A unsigned integer  buffer that receives the information.
           var lpdwIndex: DWORD                    // [in, out] Pointer to a zero-based header index used to enumerate multiple headers with
                                                   //      the same name. When calling the function, this parameter is the index of
                                                   //      the specified header to return. When the function returns, this parameter is
                                                   //      the index of the next header.
                                                   //      If the next index cannot be found, ERROR_HTTP_HEADER_NOT_FOUND is returned.

           ): boolean;
var
  lpvBuffer:pchar;
  lpdwBufferLength: DWORD;           // [in] Pointer to a value that contains the length of the data buffer, in bytes.
                                     //    When the function returns, this parameter contains the address of a value specifying
                                     //    the length of the information written to the buffer.
                                     //    When the function returns strings, the following rules apply.
                                     //    * If the function succeeds, lpdwBufferLength specifies the length of the string,
                                     //      in BYTEs, minus 1 for the terminating NULL.
                                     //    * If the function fails and ERROR_INSUFFICIENT_BUFFER is returned,
                                     //      lpdwBufferLength specifies the number of bytes that the application must allocate
                                     //      to receive the string.

begin
  lpdwBufferLength:=4;
  getMem(lpvBuffer, lpdwBufferLength);
  try
    result:=boolean(HttpQueryInfo(hRequest, dwInfoLevel, lpvBuffer, lpdwBufferLength, lpdwIndex));
    if result then
       buffer:=pdword(lpvBuffer)^;
  finally
    freeMem(lpvBuffer, lpdwBufferLength);
  end;
end;
{****************************************** END OF "InternalHttpQueryInfo" *********************************************}


{  **** Displays a dialog box for the error that is passed to InternetErrorDlg, if an appropriate dialog box exists.
        If the FLAGS_ERROR_UI_FILTER_FOR_ERRORS flag is used, the function also checks the headers for any
        hidden errors and displays a dialog box if needed.

        -------- IMPORTANT Remarks of Function -----------
        Authentication errors are hidden because the call to HttpSendRequest will complete successfully. However,
        the status code would indicate that the proxy or server requires authentication.
        The FLAGS_ERROR_UI_FILTER_FOR_ERRORS flag causes the function to search the headers for status codes
        that indicate user input is needed.
}
{  See http://msdn.microsoft.com/workshop/networking/wininet/reference/functions/interneterrordlg.asp                   }
function TINETApi_Intf.InternetErrorDlg(
           hWnd: HWND;                             // [in] Handle to the parent window for any needed dialog box.
                                                   //    This parameter can be NULL if no dialog box is needed.
           hRequest: HINTERNET;                    // [in, out] HINTERNET handle to the Internet connection used in the call to HttpSendRequest.
           dwError: DWORD;                         // [in] Error value for which to display a dialog box. This can be one of the following values:
                                                   //    ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR : Notifies the user of the zone crossing to and from a secure site.
                                                   //    ERROR_INTERNET_INCORRECT_PASSWORD     : Displays a dialog box requesting the user's name and password. (On Microsoft® Windows® 95, the function attempts to use any cached authentication information for the server being accessed before displaying a dialog box.)
                                                   //    ERROR_INTERNET_INVALID_CA             : Notifies the user that the Microsoft Win32® Internet function does not recognize the certificate authority that generated the certificate for this Secure Sockets Layer (SSL) site.
                                                   //    ERROR_INTERNET_POST_IS_NON_SECURE     : Displays a warning about posting data to the server through a nonsecure connection.
                                                   //    ERROR_INTERNET_SEC_CERT_CN_INVALID    : Indicates that the SSL certificate Common Name (host name field) is incorrect. Displays an Invalid SSL Common Name dialog box and lets the user view the incorrect certificate. Also allows the user to select a certificate in response to a server request.
                                                   //    ERROR_INTERNET_SEC_CERT_DATE_INVALID  : Tells the user that the SSL certificate has expired.
           dwFlags: DWORD;                         // [in] Unsigned long integer value that contains the action flags. This can be a combination of these values:
                                                   //    FLAGS_ERROR_UI_FILTER_FOR_ERRORS      : Scans the returned headers for errors. Call this flag after using HttpSendRequest. This option detects any hidden errors, such as an authentication error.
                                                   //    FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS   : If the function succeeds, stores the results of the dialog box in the Internet handle.
                                                   //    FLAGS_ERROR_UI_FLAGS_GENERATE_DATA    : Queries the Internet handle for needed information. The function constructs the appropriate data structure for the error. (For example, for Cert CN failures, the function grabs the certificate.)
                                                   //    FLAGS_ERROR_UI_SERIALIZE_DIALOGS      : Serializes authentication dialog boxes for concurrent requests on a password cache entry. The lppvData parameter should contain the address of a pointer to an INTERNET_AUTH_NOTIFY_DATA structure, and the client should implement a thread-safe, nonblocking callback function.
           var lppvData: Pointer                   // [in, out] Address of a pointer to a data structure.
                                                   //    The structure can be different for each error that needs to be handled.
           ): DWORD;                               // Returns one of the following values, or an error value otherwise.
                                                   //    ERROR_SUCCESS              : The function completed successfully. In the case of authentication this indicates that the user clicked the Cancel button.
                                                   //    ERROR_CANCELLED            : The function was canceled by the user.
                                                   //    ERROR_INTERNET_FORCE_RETRY : This indicates that the Win32 function needs to redo its request. In the case of authentication this indicates that the user clicked the OK button.
                                                   //    ERROR_INVALID_HANDLE       : The handle to the parent window is invalid.
begin
  result := InternetErrorDlg(hWnd, hRequest, dwError, dwFlags, lppvData);

end;
{******************************************** END OF "InternetErrorDlg" ************************************************}


{***********************************************************************************************************************}
{***************************************** PUBLIC METHODS OF TINETApi_Intf Class ***************************************}
{***********************************************************************************************************************}


{  **** Registers Global OnInternetCallBackEvent broker function as Callback and
adds Calbacks list if successfully registered with given internet handle         }
function TINETApi_Intf.RegisterCallback (hInet: HINTERNET; pContext:PInternetCallbackContext; EventToHook:TInternet_Status_Callback_proc):boolean;
var
  oldCallBack: PFNInternetStatusCallback;
  //CallBackItem: TInternetCallbackHolder;
begin
  oldCallBack:=InternalInternetSetStatusCallback(hInet,@InternetCallBackDispatcher);
  result:=(not (integer(oldCallBack)=INTERNET_INVALID_STATUS_CALLBACK));
  {
  if result then  //successfully registered add to our list!
  begin
    pContext.CallbackID:=Callbacks.Count;
    CallBackItem := TInternetCallbackHolder.Create;
    CallBackItem.hInet:=hInet;
    CallBackItem.Context:=pContext;
    CallBackItem.CallBackProc :=EventToHook;
    Callbacks.Add(CallBackItem);
  end;
  }
end;
{  **** Unregisters Previously Registeres Callback }
function TINETApi_Intf.UnregisterCallBack (CallBackId:integer;hInet:HINTERNET):boolean;
var
  oldCallBack: PFNInternetStatusCallback;
  //CallBackItem: TInternetCallbackHolder;
begin
  oldCallBack:=InternalInternetSetStatusCallback(hInet,nil);
  result:=(not (integer(oldCallBack)=INTERNET_INVALID_STATUS_CALLBACK)) and (oldCallBack=@InternetCallBackDispatcher);
  {
  try
    if CallbackId<Callbacks.Count then
    begin
      CallBackItem:=TInternetCallbackHolder(Callbacks[CallbackId]);
      Callbacks.Remove(CallBackItem);
    end;
  except on e:exception do
  end;
  }
end;

{***********************************************************************************************************************}
{************************************* TCustomInternetComponent Class Implementation ***********************************}
{***********************************************************************************************************************}

{TCustomInternetComponent}

constructor TCustomInternetComponent.Create(aOwner:TComponent);
begin
  inherited Create(aOwner);
  fApiInterface := TINETApi_Intf.Create;
  fApiOptions   := TINETApi_Options.create(self);
  WindowHandle  := AllocateHWnd(WndProc);
end;

destructor  TCustomInternetComponent.Destroy;
begin
  fApiInterface.Free;
  DeallocateHWnd(WindowHandle);
  inherited Destroy;
end;
function  TCustomInternetComponent.getHandle:HINTERNET;
begin
  result:=fHandle;
end;

procedure TCustomInternetComponent.setHandle(p:HINTERNET);
begin
  fHandle:=p;
end;

function  TCustomInternetComponent.getCallBackContext:TInternetCallbackContext;
begin
  result:=fCallBackContext;
end;

procedure TCustomInternetComponent.setCallBackContext(p:TInternetCallbackContext);
begin
  fCallBackContext:=p;
end;

function  TCustomInternetComponent.get_pCallBackContext:PInternetCallbackContext;
begin
  result:=@fCallBackContext;
end;

//  Triggered when the connection to the server is Closing .
//  [ API FLAG: INTERNET_STATUS_CLOSING_CONNECTION   ]
procedure TCustomInternetComponent.doOnClosingConnection(hInet:HINTERNET; dwContext:DWORD);
begin
  doOnProgress(HInet,dwContext,INTERNET_STATUS_CLOSING_CONNECTION,sProgressMessage_ClosingConnection);
end;

//  Triggered when Successfully connected to the socket address (pointed by SOCKADDR)
//  [ API FLAG: INTERNET_STATUS_CONNECTED_TO_SERVER  ]
procedure TCustomInternetComponent.doOnConnectedToServer(hInet:HINTERNET; dwContext:DWORD ;SockAddr:pchar);
var s:string;
begin
  s:=format(sProgressMessage_ConnectedToServer,[string(SockAddr)]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_CONNECTED_TO_SERVER,s);
end;

//  Triggered when Connecting to the socket address (pointed by SOCKADDR)
//  [ API FLAG: INTERNET_STATUS_CONNECTING_TO_SERVER ]
procedure TCustomInternetComponent.doOnConnectingToServer (hInet:HINTERNET; dwContext:DWORD; SockAddr:pchar);
var s:string;
begin
  s:=format(sProgressMessage_ConnectingToServer,[string(SockAddr)]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_CONNECTING_TO_SERVER,s);
end;

//  Triggered when Successfully closed the connection to the server.
//  [ API FLAG: INTERNET_STATUS_CONNECTION_CLOSED    ]
procedure TCustomInternetComponent.doOnConnectionClosed(hInet:HINTERNET; dwContext:DWORD);
begin
  doOnProgress(hInet,dwContext,INTERNET_STATUS_CONNECTION_CLOSED,sProgressMessage_ConnectionClosed);
end;

//  Triggered when a proxy has been detected.
//  [ API FLAG: INTERNET_STATUS_DETECTING_PROXY      ]
procedure TCustomInternetComponent.doOnDetectingProxy(hInet:HINTERNET; dwContext:DWORD);
begin
  doOnProgress(hInet,dwContext,INTERNET_STATUS_DETECTING_PROXY,sProgressMessage_DetectingProxy);
end;

//  Triggered when a handle value has been terminated.
//  [ API FLAG: INTERNET_STATUS_HANDLE_CLOSING       ]
procedure TCustomInternetComponent.doOnHandleClosing(hInet:HINTERNET; dwContext:DWORD);
begin
  //doOnProgress(hInet,INTERNET_STATUS_HANDLE_CLOSING,sProgressMessage_ClosingHandle);
end;

//  Used by InternetConnect to indicate it has created the new handle.
//    This lets the application call InternetCloseHandle from another thread, if the connect is taking too long.
//  [ API FLAG: INTERNET_STATUS_HANDLE_CREATED       ]
procedure TCustomInternetComponent.doOnHandleCreated(hInet:HINTERNET; dwContext:DWORD;
                  pAsyncResult:LPINTERNET_ASYNC_RESULT);
begin
  doOnProgress(hInet,dwContext,INTERNET_STATUS_HANDLE_CREATED,sProgressMessage_HandleCreated);
  fCanAsyncRead:=false;
 // if pAsyncResult.dwError=ERROR_SUCCESS then
 // begin
    hAsyncHandle:=HINTERNET(pAsyncResult.dwResult);
 // end;
end;

//  Triggered when an intermediate (100 level) status code Received  from the server.
//  [ API_FLAG: INTERNET_STATUS_INTERMEDIATE_RESPONSE]
procedure TCustomInternetComponent.doOnIntermediateResponse(hInet:HINTERNET; dwContext:DWORD;
                                   ResponseCode:dword);
var s:string;
begin
  s:=Format(sProgressMessage_IntermediateResponse,[ResponseCode]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_INTERMEDIATE_RESPONSE,s);
end;

//  Triggered when Successfully found the IP address of the name
//  [ API FLAG: INTERNET_STATUS_NAME_RESOLVED        ]
procedure TCustomInternetComponent.doOnNameResolved(hInet:HINTERNET; dwContext:DWORD; IPAddr:pchar);
var s:string;
begin
  s:=format(sProgressMessage_NameResolved,[string(IpAddr)]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_NAME_RESOLVED,s);
end;

//  Triggered when start to wait for the server to respond to a request.
//  [ API FLAG: INTERNET_STATUS_RECEIVING_RESPONSE   ]
procedure TCustomInternetComponent.doOnWaitingForResponse(hInet:HINTERNET; dwContext:DWORD);
begin
  doOnProgress(hInet,dwContext,INTERNET_STATUS_RECEIVING_RESPONSE,sProgressMessage_WaitingForResponse);
end;

//  Triggered when an HTTP request is about to automatically redirect the request.
//  At this point, the application can read any data returned by the server with the redirect response and can query the response headers.
//   It can also cancel the operation by closing the handle. This callback is not made if the original request specified INTERNET_FLAG_NO_AUTO_REDIRECT.
//  [ API FLAG: INTERNET_STATUS_REDIRECT             ]
procedure TCustomInternetComponent.doOnRedirect(hInet:HINTERNET; dwContext:DWORD; newURL :pchar);
var s:string;
begin
  s:=format(sProgressMessage_Redirect,[string(newURL)]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_REDIRECT,'Redireting to :'+s);
end;

//  Triggered when an asynchronous operation has been completed.
//  [ API FLAG: INTERNET_STATUS_REQUEST_COMPLETE     ]
procedure TCustomInternetComponent.doOnRequestComplete(hInet:HINTERNET; dwContext:DWORD;
                  pAsyncResult:LPINTERNET_ASYNC_RESULT);
begin
  // INTERNET_ASYNC_RESULT - this structure is returned to the application via
  // the callback with INTERNET_STATUS_REQUEST_COMPLETE. It is not sufficient to
  // just return the result of the async operation. If the API failed then the
  // app cannot call GetLastError() because the thread context will be incorrect.
  // Both the value returned by the async API and any resultant error code are
  // made available. The app need not check dwError if dwResult indicates that
  // the API succeeded (in this case dwError will be ERROR_SUCCESS)
  doOnProgress(hInet,dwContext,INTERNET_STATUS_REQUEST_COMPLETE,sProgressMessage_RequestCompleted);
  if pAsyncResult.dwError=ERROR_SUCCESS then
  begin
    fCanAsyncRead:=true;
    fLastAsyncError:=0;
    if pAsyncResult.dwResult<>1 then
      hAsyncHandle:=hinternet(pAsyncResult.dwResult);
  end
  else
    fLastAsyncError:=pAsyncResult.dwError;
end;

//  Triggered when an information request successfully sent to the server.
//  [ API FLAG: INTERNET_STATUS_REQUEST_SENT         ]
procedure TCustomInternetComponent.doOnRequestSent(hInet:HINTERNET; dwContext:DWORD; pReqLength: pdword);
var s:string;
begin
  s:=Format(sProgressMessage_RequestSent,[pReqLength^]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_REQUEST_SENT,s);
end;

//  Triggered when looking up a IP address of the name
//  [ API FLAG: INTERNET_STATUS_RESOLVING_NAME       ]
procedure TCustomInternetComponent.doOnResolvingName(hInet:HINTERNET; dwContext:DWORD;pIPAddr: pchar);
var s:string;
begin
  s:=Format(sProgressMessage_ResolvingName,[string(pIPAddr)]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_RESOLVING_NAME,s);
end;

//  Triggered when a response successfully received from the server.
//  [ API FLAG: INTERNET_STATUS_RESPONSE_RECEIVED    ]
procedure TCustomInternetComponent.doOnResponseReceived(hInet:HINTERNET; dwContext:DWORD;pResLength: pdword);
var s:string;
begin
  s:=Format(sProgressMessage_ResponseReceived,[pResLength^]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_RESPONSE_RECEIVED,s);
end;

//  Triggered when sending an information request to the server.
//  [ API FLAG: INTERNET_STATUS_SENDING_REQUEST      ]
procedure TCustomInternetComponent.doOnSendingRequest(hInet:HINTERNET; dwContext:DWORD);
begin
  doOnProgress(hInet,dwContext,INTERNET_STATUS_SENDING_REQUEST,sProgressMessage_SendingRequest);
end;

//  Triggered when moved between a secure (HTTPS) and a nonsecure (HTTP) site.
//  [ API FLAG: INTERNET_STATUS_STATE_CHANGE         ]
procedure TCustomInternetComponent.doOnStateChange(hInet:HINTERNET; dwContext:DWORD;pExtraInfo:pdword);
var s:string;
begin
  s:=Format(sProgressMessage_StateChange,[pExtraInfo^]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_STATE_CHANGE,s);
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_COOKIE_SENT          ]
procedure TCustomInternetComponent.doOnCookieSent(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
var s:string;
begin
  s:=Format(sProgressMessage_CookieSent,[pdword(pStatusInfo)^]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_COOKIE_SENT,s);
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_COOKIE_RECEIVED      ]
procedure TCustomInternetComponent.doOnCookieRecieved(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
var s:string;
begin
  s:=Format(sProgressMessage_CookieReceived,[pdword(pStatusInfo)^]);
  doOnProgress(hInet,dwContext,INTERNET_STATUS_COOKIE_RECEIVED,s);
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_PRIVACY_IMPACTED     ]
procedure TCustomInternetComponent.doOnPrivacyImpacted(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
begin
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_P3P_HEADER           ]
procedure TCustomInternetComponent.doOnP3PHeader(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
begin
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_P3P_POLICYREF        ]
procedure TCustomInternetComponent.doOnP3PpolicyRef(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
begin
end;

//  Undocumented!
//  [API FLAG: INTERNET_STATUS_COOKIE_HISTORY       ]
procedure TCustomInternetComponent.doOnCookieHistory(hInet:HINTERNET; dwContext:DWORD; pStatusInfo:pointer);
begin
end;

// Triggered whenever a progress related event occurred. Thi is a derived event so there is no coressponding Api Flag.
procedure TCustomInternetComponent.doOnProgress(hInet:HINTERNET;Progress,ProgressMax, StatusCode: Cardinal;
        StatusText: string; ElapsedTime, EstimatedTime:TDatetime;Speed :extended;
        SpeedUnit: string);
begin
  if assigned(fOnProgress) then
    fOnProgress(self, hInet, Progress, ProgressMax, StatusCode, StatusText, ElapsedTime, EstimatedTime, Speed, SpeedUnit);
end;

// Overloaded version of previous trigger processor
procedure TCustomInternetComponent.doOnProgress(hInet:HINTERNET;dwContext:DWORD;StatusCode: Cardinal;StatusText: string);

begin

  doOnProgress(hInet, fLastProgress, fLastProgressMax, StatusCode, StatusText, fLastElapsedTime, fLastEstimatedTime, fLastSpeed, fLastSpeedUnit);
end;

// Main (Default) Callback Processor Routine. This Processor simply aimed to dispatch (and convert) a callback to another specific processors
procedure TCustomInternetComponent.doOnStatusCallback (
          hInet:HINTERNET;                      // Handle for which the callback function is being called.
          dwContext:DWORD;                      // Pointer to an unsigned long integer value that contains the application-defined context value associated with hInternet.
          dwInternetStatus:DWORD;               // Unsigned long integer value that contains the status code that indicates
          lpvStatusInformation:pointer;         // Pointer to a buffer that contains information pertinent to this call to the callback function.
          dwStatusInformationLength:DWORD);     // Unsigned long integer value that contains the size, in TCHARs, of the lpvStatusInformation buffer.
begin
  if csDestroying in componentState then
    exit;
  try
    case dwInternetStatus of
      INTERNET_STATUS_CLOSING_CONNECTION   : doOnClosingConnection(hInet, dwContext);     //  Closing the connection to the server. The lpvStatusInformation parameter is NULL.
      INTERNET_STATUS_CONNECTED_TO_SERVER  : doOnConnectedToServer(hInet, dwContext,      //  Successfully connected to the socket address (SOCKADDR) pointed to by lpvStatusInformation
                                                         pchar(lpvStatusInformation));
      INTERNET_STATUS_CONNECTING_TO_SERVER : doOnConnectingToServer(hInet, dwContext,       //  Connecting to the socket address (SOCKADDR) pointed to by lpvStatusInformation.
                                                         pchar(lpvStatusInformation));
      INTERNET_STATUS_CONNECTION_CLOSED    : doOnConnectionClosed(hInet, dwContext);      //  Successfully closed the connection to the server. The lpvStatusInformation parameter is NULL.
      INTERNET_STATUS_CTL_RESPONSE_RECEIVED: begin end;                                   //  Not implemented.
      INTERNET_STATUS_DETECTING_PROXY      : doOnDetectingProxy(hInet, dwContext);        //  Notifies the client application that a proxy has been detected.
      INTERNET_STATUS_HANDLE_CLOSING       : doOnHandleClosing(hInet, dwContext);          //  This handle value has been terminated.
      INTERNET_STATUS_HANDLE_CREATED       : doOnHandleCreated(hInet, dwContext,          //  Used by InternetConnect to indicate it has created the new handle. This lets the application call InternetCloseHandle from another thread, if the connect is taking too long.
                                               LPINTERNET_ASYNC_RESULT(lpvStatusInformation)); // The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
      INTERNET_STATUS_INTERMEDIATE_RESPONSE: doOnIntermediateResponse(hInet, dwContext,   //  Received an intermediate (100 level) status code message from the server.
                                               pdword(lpvStatusInformation)^);
      INTERNET_STATUS_NAME_RESOLVED        : doOnNameResolved(hInet, dwContext,           //  Successfully found the IP address of the name contained in lpvStatusInformation
                                               pchar(lpvStatusInformation));
      INTERNET_STATUS_PREFETCH             : begin end;                                   //  Not implemented.
      INTERNET_STATUS_RECEIVING_RESPONSE   : doOnWaitingForResponse(hInet, dwContext);    //  Waiting for the server to respond to a request. The lpvStatusInformation parameter is NULL.
      INTERNET_STATUS_REDIRECT             : doOnRedirect(hInet, dwContext,               //  An HTTP request is about to automatically redirect the request. The lpvStatusInformation parameter points to the new URL. At this point, the application can read any data returned by the server with the redirect response and can query the response headers. It can also cancel the operation by closing the handle. This callback is not made if the original request specified INTERNET_FLAG_NO_AUTO_REDIRECT.
                                               pchar(lpvStatusInformation));
      INTERNET_STATUS_REQUEST_COMPLETE     : doOnRequestComplete(hInet, dwContext,        //  An asynchronous operation has been completed.
                                               LPINTERNET_ASYNC_RESULT(lpvStatusInformation)); //  The lpvStatusInformation parameter contains the address of an INTERNET_ASYNC_RESULT structure.
      INTERNET_STATUS_REQUEST_SENT         : doOnRequestSent(hInet, dwContext,            //  Successfully sent the information request to the server.
                                               pdword(lpvStatusInformation));             //    The lpvStatusInformation parameter points to a DWORD containing the number of bytes sent.
      INTERNET_STATUS_RESOLVING_NAME       : doOnResolvingName(hInet, dwContext,          //  Looking up the IP address of the name contained in lpvStatusInformation
                                               pchar(lpvStatusInformation));
      INTERNET_STATUS_RESPONSE_RECEIVED    : doOnResponseReceived(hInet, dwContext,      //  Successfully received a response from the server.
                                               pdword(lpvStatusInformation));            //    The lpvStatusInformation parameter points to a DWORD containing the number of bytes received.
      INTERNET_STATUS_SENDING_REQUEST      : doOnSendingRequest(hInet, dwContext);       //  Sending the information request to the server. The lpvStatusInformation parameter is NULL.
      INTERNET_STATUS_STATE_CHANGE         : doOnStateChange(hInet, dwContext,           //  Moved between a secure (HTTPS) and a nonsecure (HTTP) site.
                                               pdword(lpvStatusInformation));
      INTERNET_STATUS_COOKIE_SENT          : doOnCookieSent(hInet,dwContext,             //  Undocumented!
                                                   lpvStatusInformation);
      INTERNET_STATUS_COOKIE_RECEIVED      : doOnCookieRecieved(hInet,dwContext,         //  Undocumented!
                                                   lpvStatusInformation);
      INTERNET_STATUS_PRIVACY_IMPACTED     : doOnPrivacyImpacted(hInet,dwContext,        //  Undocumented!
                                                   lpvStatusInformation);
      INTERNET_STATUS_P3P_HEADER           : doOnP3PHeader(hInet,dwContext,              //  Undocumented!
                                                   lpvStatusInformation);
      INTERNET_STATUS_P3P_POLICYREF        : doOnP3PpolicyRef(hInet,dwContext,           //  Undocumented!
                                                   lpvStatusInformation);
      INTERNET_STATUS_COOKIE_HISTORY       : doOnCookieHistory(hInet,dwContext,          //  Undocumented!
                                                   lpvStatusInformation);
    end;
  except on e:exception do
  end;
end;


function  TCustomInternetComponent.getOnClosingConnection:TInternetOnClosingConnectionEvent;
begin
  result:=fOnClosingConnection;
end;

procedure TCustomInternetComponent.setOnClosingConnection(p:TInternetOnClosingConnectionEvent);
begin
  fOnClosingConnection:=p;
end;

function  TCustomInternetComponent.getOnConnectedToServer:TInternetOnConnectedEvent;
begin
  result:=fOnConnectedToServer;
end;

procedure TCustomInternetComponent.setOnConnectedToServer(p:TInternetOnConnectedEvent);
begin
  fOnConnectedToServer:=p;
end;

function  TCustomInternetComponent.getOnConnectingToServer:TInternetOnConnectingEvent;
begin
  result:=fOnConnectingToServer;
end;

procedure TCustomInternetComponent.setOnConnectingToServer(p:TInternetOnConnectingEvent);
begin
  fOnConnectingToServer:=p;
end;

function  TCustomInternetComponent.getOnConnectionClosed:TInternetOnConnectionClosedEvent;
begin
  result:=fOnConnectionClosed;
end;

procedure TCustomInternetComponent.setOnConnectionClosed(p:TInternetOnConnectionClosedEvent);
begin
  fOnConnectionClosed:=p;
end;

function  TCustomInternetComponent.getOnDetectingProxy:TInternetOnDetectingProxyEvent;
begin
  result:=fOnDetectingProxy;
end;

procedure TCustomInternetComponent.setOnDetectingProxy(p:TInternetOnDetectingProxyEvent);
begin
  fOnDetectingProxy:=p;
end;

function  TCustomInternetComponent.getOnHandleCreated:TInternetOnHandleCreatedEvent;
begin
  result:=fOnHandleCreated;
end;

procedure TCustomInternetComponent.setOnHandleCreated(p:TInternetOnHandleCreatedEvent);
begin
  fOnHandleCreated:=p;
end;

function  TCustomInternetComponent.getOnHandleClosingEvent:TInternetOnHandleClosingEvent;
begin
  result:=fOnHandleClosing;
end;

procedure TCustomInternetComponent.setOnHandleClosingEvent(p:TInternetOnHandleClosingEvent);
begin
  fOnHandleClosing:=p;
end;

function  TCustomInternetComponent.getOnHostNameResolvedEvent:TInternetOnHostNameResolvedEvent;
begin
  result:=fOnHostNameResolved;
end;

procedure TCustomInternetComponent.setOnHostNameResolvedEvent(p:TInternetOnHostNameResolvedEvent);
begin
  fOnHostNameResolved:=p;
end;

function  TCustomInternetComponent.getOnRedirect:TInternetOnRedirectEvent;
begin
  result:=fOnRedirect;
end;

procedure TCustomInternetComponent.setOnRedirect(p:TInternetOnRedirectEvent);
begin
  fOnRedirect:=p;
end;

function  TCustomInternetComponent.getOnRequestComplete:TInternetOnRequestCompleteEvent;
begin
  result:=fOnRequestComplete;
end;

procedure TCustomInternetComponent.setOnRequestComplete(p:TInternetOnRequestCompleteEvent);
begin
  fOnRequestComplete:=p;
end;

function  TCustomInternetComponent.getOnRequestSent:TInternetOnRequestSentEvent;
begin
  result:=fOnRequestSent;
end;

procedure TCustomInternetComponent.setOnRequestSent(p:TInternetOnRequestSentEvent);
begin
  fOnRequestSent:=p;
end;

function  TCustomInternetComponent.getOnResolvingHostName:TInternetOnResolvingHostNameEvent;
begin
  result:=fOnResolvingHostName;
end;

procedure TCustomInternetComponent.setOnResolvingHostName(p:TInternetOnResolvingHostNameEvent);
begin
  fOnResolvingHostName:=p;
end;

function  TCustomInternetComponent.getOnResponse:TInternetOnResponseEvent;
begin
  result:=fOnResponse;
end;

procedure TCustomInternetComponent.setOnResponse(p:TInternetOnResponseEvent);
begin
  fOnResponse:=p;
end;

function  TCustomInternetComponent.getOnResponseReceived:TInternetNotifyEvent;
begin
  result:=fOnResponseReceived;
end;

procedure TCustomInternetComponent.setOnResponseReceived(p:TInternetNotifyEvent);
begin
  fOnResponseReceived:=p;
end;

function  TCustomInternetComponent.getOnWaitingForResponse:TInternetOnWaitingForResponseEvent;
begin
 result:=fOnWaitingForResponse;
end;

procedure TCustomInternetComponent.setOnWaitingForResponse(p:TInternetOnWaitingForResponseEvent);
begin
  fOnWaitingForResponse:=p;
end;

function  TCustomInternetComponent.getOnProgress:TInternetOnProgressEvent;
begin
  result:=fOnProgress;
end;

procedure TCustomInternetComponent.setOnProgress(p:TInternetOnProgressEvent);
begin
  fOnProgress:=p;
end;
procedure TCustomInternetComponent.WndProc(var Message: TMessage);
  procedure WM_CALLBACK;
  var pCB:PWM_CALLBACK_REC;
  begin
    pCB:=PWM_CALLBACK_REC(Message.wParam);
    if assigned(pCB) then
    try
      doOnStatusCallback(pCB.hInet,pCB.dwContext,pCB.dwInternetStatus,pCB.lpvStatusInformation,pCB.dwStatusInformationLength);
    finally
      dispose(pCB);
    end;
  end;
begin
  try
    case Message.Msg of
      WM_INTERNET_CALLBACK :WM_CALLBACK;
      else DefWindowProc(WindowHandle, Message.Msg, Message.wParam, Message.lParam);
    end;
  except on e:exception do
    DefWindowProc(WindowHandle, Message.Msg, Message.wParam, Message.lParam);
  end;
  //Dispatch(Message);
end;
{***********************************************************************************************************************}
{************************************** TCustomInternetSession Class Implementation ************************************}
{***********************************************************************************************************************}
{TCustomInternetSesion}
{    fApiInterface: TINETApi_Intf;
    fAsync       : boolean;
    fOffline     : boolean;
    fFromCache   : boolean;
    fOnProgress  : TInternetOnProgressEvent;
}
function  TCustomInternetSession.getCurrentUser:string;
begin
  result:=fCurrentUser;
end;

procedure TCustomInternetSession.setCurrentUser(p:string);
begin
  fCurrentUser:=p;
end;

function  TCustomInternetSession.getActive:boolean;
begin
  result:=getHandle<>nil;
end;
procedure TCustomInternetSession.setActive(p:boolean);
begin
  if p and (not active) then
    Open
  else
  if (not p) and active then
    Close;
end;
function  TCustomInternetSession.getServiceType:TInternetHandleTypes;
begin
  result:=ApiOptions.HANDLE_TYPE;
end;
function  TCustomInternetSession.getEnableStatusCallback:boolean;
begin
  result:=fisStatusCallbacksEnabled;
end;
procedure TCustomInternetSession.setEnableStatusCallback(p:boolean);
begin
  fisStatusCallbacksEnabled := p;
end;
function  TCustomInternetSession.getOffline:boolean;
begin
  if (active) and (not (csDesigning in ComponentState)) then
  begin
    result:=ApiOptions.OFFLINE_MODE;
    fOffline:=result;
  end
  else
    result:=fOffline;
end;
procedure TCustomInternetSession.setOffline(p:boolean);
begin
  fOffline:=p;
  if (active) and (not (csDesigning in ComponentState)) then
    ApiOptions.OFFLINE_MODE:=fOffline;
end;
function  TCustomInternetSession.getAsync:boolean;
begin
(*
  if (active) and (not (csDesigning in ComponentState)) then
  begin
    result:=ApiOptions.ASYNC;
    fAsync:=result;
  end
  else
*)
    result:=fAsync;
end;
procedure TCustomInternetSession.setAsync(p:boolean);
begin
  fAsync:=p;
(*
  if (active) and (not (csDesigning in ComponentState)) then
    ApiOptions.ASYNC:=fAsync;
*)
end;
function  TCustomInternetSession.getFromCache:boolean;
begin
  result:=fFromCache;
end;
procedure TCustomInternetSession.setFromCache(p:boolean);
begin
  if active then
    raise Exception.Create(format(sExceptionSessionActive ,['"Form Cache"']));
  fFromCache:=p;
end;
function TCustomInternetSession.GetDefaultUserAgent: string;
var
  reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings\', FALSE)
      then Result := Reg.ReadString('User Agent');
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

function  TCustomInternetSession.getUserAgent:string;
begin
  if fUserAgent='' then
    fUserAgent:=GetDefaultUserAgent;
  result:=fUserAgent;
end;
procedure TCustomInternetSession.setUserAgent(p:string);
begin
  if not active then
    fUserAgent:=p
  else
    raise Exception.Create(format(sExceptionSessionActive ,['"UserAgent"']));
end;
function  TCustomInternetSession.getAccessType:TInternetAccessTypes;
begin
  result:=fAccessType;
end;
procedure TCustomInternetSession.setAccessType(p:TInternetAccessTypes);
begin
  fAccessType:=p;
end;


function TCustomInternetSession.getApiAccessType:dword;
begin
  result:=c_InternetAccessTypeWINInetMapping[AccessType];
end;
function  TCustomInternetSession.getProxyByPassList:TStrings;
begin
  result:=fProxyByPassList;
end;
procedure TCustomInternetSession.setProxyByPassList(p:TStrings);
begin
  fProxyByPassList.Assign(p);
end;
function  TCustomInternetSession.getProxy:string;
begin
  result:=fProxy;
end;
procedure TCustomInternetSession.setProxy(p:string);
begin
  fProxy:=p;
end;
function  TCustomInternetSession.getConnection(index:integer):TCustomInternetConnection;
begin
  result:=TCustomInternetConnection(fConnections[index]);
end;
procedure TCustomInternetSession.setConnection(index:integer;p:TCustomInternetConnection);
begin
  fConnections[index]:=p;
end;

procedure TCustomInternetSession.AddConnection(aConnection:TCustomInternetConnection);
begin
  fConnections.Add(aConnection);
end;
procedure TCustomInternetSession.RemoveConnection(aConnection:TCustomInternetConnection);
begin
  fConnections.Remove(aConnection);
end;

function  TCustomInternetSession.ConnectionCount:integer;
begin
  result:=fConnections.Count;
end;
function  TCustomInternetSession.getApiFlags:dword;
begin
  result:=0;
  if Asynchronous then
    result:=result or INTERNET_FLAG_ASYNC;
  if OffLine then
    result:=result or INTERNET_FLAG_OFFLINE;
  if FromCache then
    result:=result or INTERNET_FLAG_FROM_CACHE;
end;
procedure TCustomInternetSession.Open;                                     // Activates Internet Session.
var
  hOpen:HINTERNET;
begin
  if not active then
  begin
    hOpen:=ApiInterface.InternalInternetOpen(UserAgent,getApiAccessType,Proxy, ProxyByPassList.Text, getApiFlags);
    if assigned(hOpen) then
    begin
      setHandle(hOpen);                                 // Save returned Handle
      if assigned(hOpen) then  // Register a callback
      begin
        pCallBackContext.pOwnerHandle:=hOpen;
        //ApiInterface.RegisterCallback(hOpen,nil,ApiInterface.doOnCallback);
      end;
      //ApiInterface.OnCallback:=doOnStatusCallback;      // Redirect Callbacks to this object
    end
    else
      RaiseLastAPIError;
  end;
end;

procedure TCustomInternetSession.Close;                                    // Closes Active Session.
begin
  if active then
  begin
    try
      //ApiInterface.UnregisterCallBack(pCallBackContext.CallbackID,hSession);
    finally
      try
        ApiInterface.InternalInternetCloseHandle(hSession);
      finally
        setHandle(nil);
      end;
    end;
  end;
end;

function  TCustomInternetSession.OpenURL(                                  // This method sends the specified request to the HTTP server and allows the client to specify additional RFC822, MIME, or HTTP headers to send along with the request.
      const URL:string;                                         // URL to begin reading. Only URLs beginning with file: or http: are supported.
      const dwContext:dword;                                    // Specifies an application-defined value passed with the returned handle in callback.
      const dwFlags:dword;                                      // All Flags of TINETApi_Intf.InternalInternetOpenUrl Function can be used. Default is INTERNET_FLAG_TRANSFER_ASCII.
      const Headers:string;                                      // that contains the headers to be sent to the HTTP server. (For more information, see the description of the Headers parameter in the InternalHttpSendRequest function of API Interface Object.)
      ReceiveStream:TStream
      ):boolean;                                          // Returns true if successfull.
var
  hURL:HINTERNET;

begin
  result:=false;
  hURL:=ApiInterface.InternalInternetOpenUrl(hSession,URL,Headers,dwFlags,dwContext);
  if not assigned(hURL) then
   RaiseLastAPIError;

end;

{-----------------------------------------------------------------------------------------------------------------------}
{------------------------------------ TCustomInternetSession Public Methods --------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}

constructor TCustomInternetSession.Create(aOwner:TComponent);             // Creates new Object Instance
begin
  inherited Create(aOwner);
  fCallBackContext.pOwner:=self;
  fCallBackContext.pReserved:=nil;
  fProxyByPassList := TStringList.Create;
  fConnections     := TList.Create;

end;
destructor  TCustomInternetSession.Destroy;                               // Releases the instance and its allocated memory
begin
  while fConnections.Count>0 do
  begin
    TInternetConnection(fConnections[0]).free;
  end;
  fConnections.free;
  fProxyByPassList.free;
  inherited Destroy;
end;

{***********************************************************************************************************************}
{**************************************** TCustomInternetConnection Class Implementation *************************************}
{***********************************************************************************************************************}


{TCustomInternetConnection}

{-----------------------------------------------------------------------------------------------------------------------}
{-------------------------------------- TCustomInternetConnection Public Methods ---------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}

constructor TCustomInternetConnection.Create(aOwner:TComponent);
begin
  inherited create(aOwner);
  fRequests     :=TList.Create;
  fCookieHandler:=THTTPCookies.Create(self);
end;

destructor  TCustomInternetConnection.Destroy;
begin
  try
    if Connected then
      Disconnect;

  finally
    fRequests.free;
    fCookieHandler.Free;
    Session.RemoveConnection(self);
    Session:=nil;
    inherited destroy;
  end;
end;
function  TCustomInternetConnection.RequestCount:integer;
begin
  result:=fRequests.Count;
end;
procedure TCustomInternetConnection.Connect;
var
  res:HINTERNET;
  context:dword;
begin
  if not assigned(Session) then
    raise Exception.Create(sExceptionSessionRequired);
  if Server='' then
    raise Exception.Create(sExceptionServerNameRequired);
  if not Session.Active then
    Session.Open;
  //res:=ApiInterface.InternalInternetConnect(hSession,Server,Port,Username,Password,getApiConnectionType,getApiFlags,dword(pCallbackContext));

  if Session.Asynchronous then
    context:=dword(pCallbackContext)
    //context:=dword(WindowHandle)
  else
    context:=0;
  res:=ApiInterface.InternalInternetConnect(hSession,Server,Port,Username,Password,getApiConnectionType,getApiFlags,context);
  if not assigned(res) then
    RaiseLastAPIError;
  //Register returned handle as Connection Handle (hConnection)
  setHandle(res);
  Cookies.LoadFromDisk;
  // Register Callback event
  // pCallbackContext.pOwner:=self;
  //pCallbackContext.pOwnerHandle:=res;
  ApiInterface.RegisterCallback(res,pCallbackContext,ApiInterface.doOnCallback);
  //ApiInterface.RegisterCallback(res,nil,ApiInterface.doOnCallback);
  ApiInterface.OnCallback:=doOnStatusCallback;
end;

procedure TCustomInternetConnection.Disconnect;
var
  res:boolean;
  i:integer;
begin
  try
    if Connected then
    try
      for i:=0 to RequestCount-1 do
        if TCustomInternetRequest(Requests[i]).Active then
          TCustomInternetRequest(Requests[i]).CloseRequest;
      Apiinterface.UnregisterCallBack(pCallbackContext.CallbackID,hConnection);
    finally
      res:=Apiinterface.InternalInternetCloseHandle(hConnection);
      if not res then
         //RaiseLastAPIError;
    end;
  finally
    Cookies.SaveToDisk;
    Cookies.SetDomain('');
    Cookies.Clear;
    setHandle(nil);  //anyway! set handle to null...
  end;
end;

{-----------------------------------------------------------------------------------------------------------------------}
{------------------------------------- TCustomInternetConnection Protected Methods -------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}
function  TCustomInternetConnection.getRedirecting:boolean;
begin
  result:=fRedirecting;
end;
procedure TCustomInternetConnection.setRedirecting(p:boolean);
begin
  fRedirecting:=p;
end;

function  TCustomInternetConnection.getApiConnectionType:dword;
begin
  result := INTERNET_SERVICE_HTTP;
  Case Service of
    ictHTTP  : result := INTERNET_SERVICE_HTTP;
    ictFTP   : result := INTERNET_SERVICE_FTP;
    ictGOPHER: result := INTERNET_SERVICE_GOPHER;
  end;
end;

function  TCustomInternetConnection.getApiFlags:dword;
begin
  result:=0;
  // IMPLEMENTATION NOTE:
  // Since TCustomInternetConnection is an abstract class to other derived classes, There is no flag combinations here but
  // may be implemented in descendants...
end;

function  TCustomInternetConnection.getConnected:boolean;
begin
  result:=assigned(hConnection);
end;

procedure TCustomInternetConnection.setConnected(p:boolean);
begin
  if Connected<>p then
  begin
    if Connected then
      Disconnect
    else
      Connect;
  end;
end;

function  TCustomInternetConnection.getSessionHandle:HINTERNET;
begin
  result:=nil;
  if assigned(Session) then
    result:=Session.hSession;
end;

function  TCustomInternetConnection.getSession:TCustomInternetSession;
begin
  result:=fSession;
end;

procedure TCustomInternetConnection.setSession(p:TCustomInternetSession);
begin
  if Connected then
    raise Exception.Create(format(sExceptionConnectionActive,['"Session"']));
  // Remove this connection instance from old session's connection array
  if assigned(Session) then
    Session.RemoveConnection(self);

  fSession:=p;
  // Add this connection instance to new session's connection array
  if assigned(Session) then
    Session.AddConnection(self);
end;
function  TCustomInternetConnection.getScheme:TInternetSchemes;
begin
  result:=fScheme;
end;
procedure TCustomInternetConnection.setScheme(p:TInternetSchemes);
begin
  fScheme:=p;
end;

function  TCustomInternetConnection.getServer:string;
begin
  result:=fServer;
end;

procedure TCustomInternetConnection.setServer(p:string);
begin
  if comparetext(p,fServer)<>0 then
  begin
    if Connected and (not Redirecting) then
      Connected:=False;
    fServer:=p;
    //if not (csLoading in ComponentState) then
    Cookies.SetDomain(p);
  end;
end;

function  TCustomInternetConnection.getPort:dword;
begin
  result:=fPort;
end;

procedure TCustomInternetConnection.setPort(p:dword);
begin
  if p<>fPort then
  begin
    if Connected and (not Redirecting) then
    raise Exception.Create(format(sExceptionConnectionActive,['"Port"']));
    fPort:=p;
  end;
end;

function  TCustomInternetConnection.getServiceType:TInternetConnectionTypes;
begin
  result:=fServiceType;
end;

procedure TCustomInternetConnection.setServiceType(p:TInternetConnectionTypes);
begin
  if p<>fServiceType then
  begin
    if Connected then
      raise Exception.Create(format(sExceptionConnectionActive,['"ServiceType"']));
    fServiceType:=p;
  end;
end;



function  TCustomInternetConnection.getUserName:string;
begin
  result:=fUsername;
end;

procedure TCustomInternetConnection.setUserName(p:string);
begin
  if compareText(p,fUserName)<>0 then
  begin
    if Connected and (not Redirecting) then
      raise Exception.Create(format(sExceptionConnectionActive,['"Username"']));
    fUsername:=p;
  end;
end;

function  TCustomInternetConnection.getPassword:string;
begin
  result:=fPassword;
end;

procedure TCustomInternetConnection.setPassword(p:string);
begin
  if compareText(p,fPassword)<>0 then
  begin
    if Connected and (not Redirecting) then
      raise Exception.Create(format(sExceptionConnectionActive,['"Password"']));
    fPassword:=p;
  end;
end;


function  TCustomInternetConnection.getConnectionContext:pointer;
begin
  result:=pCallbackContext.pAppData;
end;

procedure TCustomInternetConnection.setConnectionContext(p:pointer);
begin
  if Connected then
    raise Exception.Create(format(sExceptionConnectionActive,['"Context"']));
  pCallbackContext.pAppData:=p;
end;
procedure TCustomInternetConnection.getCookies(url:string;var hdqCookie:string);
var
  buf:pchar;
  bufsize:dword;
begin
  if opCookieHandling=chAPI then
  begin
    getmem(buf,4096);
    try
      if InternetGetCookie(pchar(URL),nil,buf,bufsize) then
      begin
        hdqCookie:=string(buf);
      end;
    finally
      freemem(buf,4096);
    end;
  end
  else
  if opCookieHandling=chNative then
    hdqCookie:=Cookies.GetCookieHeader;
end;
procedure TCustomInternetConnection.setCookies(Url:string;hdrCookies:TStrings);
var
  i:integer;
  tmpList:TStringList;
begin
  tmpList:=TStringList.Create;
  try
    tmpList.assign(hdrCookies);
    for i:=0 to tmpList.Count-1 do
      if tmpList[i]<>'' then
      case opCookieHandling of
        chNative: Cookies.PlaceCookie(tmpList[i]);
        chAPI   : if not InternetSetCookie(pchar(URL),nil,pchar(tmpList[i])) then RaiseLastOSError;
      end;
  finally
    tmpList.free;
  end;
end;
function  TCustomInternetConnection.get_opCookieHandling:THTTPCookieHandlingTypes;
begin
  result:=fCookieHandling;
end;
procedure TCustomInternetConnection.set_opCookieHandling(p:THTTPCookieHandlingTypes);
begin
  fCookieHandling:=p;
end;
function  TCustomInternetConnection.getRequest(index:integer):TCustomInternetRequest;
begin
  result:=TCustomInternetRequest(fRequests[index]);
end;
procedure TCustomInternetConnection.setRequest(index:integer;p:TCustomInternetRequest);
begin
  fRequests[index]:=p;
end;

procedure TCustomInternetConnection.AddRequest(aRequest:TCustomInternetRequest);
begin
  fRequests.Add(aRequest);
end;

procedure TCustomInternetConnection.RemoveRequest(aRequest:TCustomInternetRequest);
begin
  fRequests.Remove(aRequest);
end;

{***********************************************************************************************************************}
{************************************** TCustomInternetRequest Class Implementation ************************************}
{***********************************************************************************************************************}
function  TCustomInternetRequest.getActive:boolean;
begin
  result:=assigned(hRequest);
end;
procedure TCustomInternetRequest.setActive(p:boolean);
begin
  if p<>Active then
  if Active then
    CloseRequest
  else
    OpenRequest;
end;
function  TCustomInternetRequest.getOnLoaded:TInternetOnLoadedEvent;
begin
  result:=fonLoaded;
end;
procedure TCustomInternetRequest.setOnLoaded(p:TInternetOnLoadedEvent);
begin
  fonLoaded:=p;
end;
procedure TCustomInternetRequest.CancelAsyncRequest;
begin
  if Assigned(AsyncReader) then
    AsyncReader.Terminate;
end;
procedure TCustomInternetRequest.doOnReaderTerminate(Sender:TObject);
begin

  if assigned(fOnloaded) and (not Connection.Redirecting) and (AsyncStatus=asFinished) then
  begin
      fOnLoaded(Self,hRequest,fReceiverStream);
      AsyncReader:=nil;
  end;
end;
procedure TCustomInternetRequest.Loaded;
begin
  inherited;
  Scheme:=fscheme;
  URL:=fURL;
end;
function  TCustomInternetRequest.getURLComponents:TURL_Components;
begin
  result.Scheme:=c_InternetSchemeIds[scheme];
  result.nScheme:=scheme;
  result.HostName:=Server;
  result.nPort:=Port;
  result.pad:=0;
  result.UserName:=UserName;
  result.Password:=Password;
  result.UrlPath:=ObjectName;
  result.ExtraInfo:=ExtraInfo;
end;
function  TCustomInternetRequest.getConnection:TCustomInternetConnection;
begin
  result:=fConnection;
end;

procedure TCustomInternetRequest.setConnection(p:TCustomInternetConnection);
begin
  fConnection:=p;
end;
function  TCustomInternetRequest.getURL:string;

begin
  if not (csLoading in ComponentState) then
  if not ApiInterface.InternalInternetCreateUrl(getURLComponents,[icoESCAPE,icoUSERNAME],result) then
    RaiseLastAPIError;
end;
procedure TCustomInternetRequest.setURL(p:string);
var
  UrlComponents:TURL_Components;

begin
  if (csLoading in ComponentState) then
  begin
     furl:=p;
     exit;
  end;
  if Connection.Connected then
    Connection.Connected:=false;
  if p='http://' then exit;
  if not InternalInternetCrackUrl(p,[icoDecode],UrlComponents) then
    RaiseLastAPIError;

  Scheme:=UrlComponents.nScheme;
  Server:=UrlComponents.HostName;
  Port:=UrlComponents.nPort;
  UserName:=UrlComponents.UserName;
  Password:=UrlComponents.Password;
  ObjectName:=UrlComponents.UrlPath;
  ExtraInfo:=UrlComponents.ExtraInfo;
end;
function  TCustomInternetRequest.getScheme:TInternetSchemes;
begin
  if assigned(Connection) then
    result:=Connection.Scheme
  else
    result:=isUnknown;
end;
procedure TCustomInternetRequest.setScheme(p:TInternetSchemes);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Scheme:=p;
  end
  else
    fscheme:=p;
end;
function  TCustomInternetRequest.getServer:string;
begin
  if assigned(Connection) then
    result:=Connection.Server;
end;
procedure TCustomInternetRequest.setServer(p:string);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //  raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Server:=p;
  end;
end;
function  TCustomInternetRequest.getPort:dword;
begin
  if not (csLoading in ComponentState) then
  begin
    if assigned(Connection) then
      result:=Connection.Port
    else
      result:=INTERNET_INVALID_PORT_NUMBER;
  end
  else
    result:=INTERNET_INVALID_PORT_NUMBER;
end;
procedure TCustomInternetRequest.setPort(p:dword);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //  raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Port:=p;
  end;
end;

function  TCustomInternetRequest.getServiceType:TInternetConnectionTypes;
begin
  if not (csLoading in ComponentState) then
  begin
    if assigned(Connection) then
      result:=Connection.Service
    else
      result:=ictUnknown;
  end
  else
    result:=ictUnknown;
end;
procedure TCustomInternetRequest.setServiceType(p:TInternetConnectionTypes);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //  raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Service:=p;
  end;
end;
function  TCustomInternetRequest.getUserName:string;
begin
  if not (csLoading in ComponentState) then
  begin
    if assigned(Connection) then
      result:=Connection.Username;
  end
  else
    result:=''
end;
procedure TCustomInternetRequest.setUserName(p:string);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //  raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Username:=p;
  end;
end;
function  TCustomInternetRequest.getPassword:string;
begin
  if not (csLoading in ComponentState) then
  begin
    if assigned(Connection) then
      result:=Connection.Password;
  end
  else
    result:='';
end;
procedure TCustomInternetRequest.setPassword(p:string);
begin
  if not (csLoading in ComponentState) then
  begin
    //if not assigned(Connection) then
    //  raise exception.Create(sExceptionConnectionExpected);
    if assigned(Connection) then
      Connection.Password:=p;
  end;
end;
function  TCustomInternetRequest.getObjectName:string;
begin
  result:=fObjectName;
end;
procedure TCustomInternetRequest.setObjectName(p:string);
begin
  fObjectName:=p;
end;
function  TCustomInternetRequest.getExtraInfo:string;
begin
  result:=fExtraInfo;
end;
procedure TCustomInternetRequest.setExtraInfo(p:string);
begin
  fExtraInfo:=p;
end;

{***********************************************************************************************************************}
{************************************** TInternetDataReader Class Implementation ***************************************}
{***********************************************************************************************************************}



{TInternetDataReader}


{-----------------------------------------------------------------------------------------------------------------------}
{------------------------------------ TInternetDataReader Public Methods -------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}

constructor TInternetDataReader.create(request:TCustomInternetRequest;dwContext:dword);
begin
  inherited Create(true);
  fRequest:=request;
  fContext:=dwContext;

end;
destructor TInternetDataReader.destroy;
begin
  inherited;
end;
procedure TInternetDataReader.triggerProgessEvent;
begin
  progress:=TotalRead;
  if progress>progressMax then
    progress:=progressMax;
  fRequest.doOnProgress(fRequest.hRequest,progress,progressMax,INTERNET_STATUS_DOWNLOADING,'Downloading content',0,0,0,'');
end;
procedure TInternetDataReader.execute;
var
 BuffersOut:INTERNET_BUFFERS;
 pBuffersOut:pointer;
 dwNumberOfBytesToRead:dword;



begin
    fRequest.hAsyncHandle:=nil;
    fRequest.fCanAsyncRead:=false;
    fRequest.ApiInterface.RegisterCallback(fRequest.Connection.hSession,fRequest.pCallbackContext,fRequest.ApiInterface.doOnCallback);
    fRequest.ApiInterface.OnCallback:=fRequest.doOnStatusCallback;
    fRequest.fAsyncStatus:=asInit;
    try
      fRequest.ApiInterface.InternalInternetOpenUrl(fRequest.Connection.hSession,fRequest.URL,'',TInternetHTTPRequest(fRequest).getApiHttpFlags,dword(fRequest.WindowHandle));


      while not fRequest.fCanAsyncRead do
      begin
        if Terminated then break;
        sleep(10);
        if fRequest.Connection.Redirecting then
        begin
            try
              {if assigned(fRequest.hAsyncHandle) then
              begin
                if not fRequest.ApiInterface.InternalInternetCloseHandle(fRequest.hAsyncHandle) then
                  RaiseLastAPIError;
                fRequest.hAsyncHandle:=nil;

              end;
              }
              fRequest.hAsyncHandle:=fRequest.ApiInterface.InternalInternetOpenUrl(fRequest.Connection.hSession,fRequest.fNewUrl,'',TInternetHTTPRequest(fRequest).getApiHttpFlags,dword(fRequest.WindowHandle));

            finally
              fRequest.Connection.Redirecting:=false;
              fRequest.fNewUrl:='';
              while (GetLastError=ERROR_IO_PENDING) do
              begin
                if fRequest.fLastAsyncError<>0 then
                  RaiseLastAPIError(fRequest.fLastAsyncError);
                if terminated then break;
                sleep(10);
                if assigned(fRequest.hAsyncHandle) then
                  break;

              end;

            end;
        end;
      end;
      //sleep(10);
      if not Terminated then
      begin

        fRequest.fAsyncStatus:=asReading;
        BuffersOut.lpcszHeader:=nil;
        BuffersOut.dwHeadersLength:=0;
        BuffersOut.dwHeadersTotal:=0;

        pBuffersOut:=@BuffersOut;
        BuffersOut.Next:=nil;
        BuffersOut.dwStructSize:=sizeof(BuffersOut);

        BuffersOut.dwOffsetLow:=0;
        BuffersOut.dwOffsetHigh:=0;
        getmem(BuffersOut.lpvBuffer,4096);
        BuffersOut.dwBufferLength:=4096;
        BuffersOut.dwBufferTotal:=BuffersOut.dwBufferLength;
        TotalRead:=0;
        progressMax:=0;
        //fContext:=dword(fRequest.pCallbackContext);
        try
          //sleep(1);
          if (not fRequest.ApiInterface.InternalInternetQueryDataAvailable(fRequest.hAsyncHandle,dwNumberOfBytesToRead,0,0)) and (GetLastError<> ERROR_IO_PENDING) then
            RaiseLastAPIError;
          if dwNumberOfBytesToRead=0 then
            sleep(50);
          if progressMax=0 then
          begin
            if fRequest is TInternetHTTPRequest then
              progressMax:=TInternetHTTPRequest(fRequest).hdrContentLength;
            if progressMax=0 then
              progressMax:=c_default_document_size;
            Synchronize(triggerProgessEvent);
          end;

          InternetReadFileEx(fRequest.hAsyncHandle,pBuffersOut,IRF_NO_WAIT,fContext);

          while (GetLastError=ERROR_IO_PENDING) do
          begin
            if terminated then break;
            sleep(100);
            InternetReadFileEx(fRequest.hAsyncHandle,pBuffersOut,IRF_NO_WAIT,fContext);
            if (GetLastError<>ERROR_IO_PENDING) then
                    RaiseLastAPIError;

          end;
          fRequest.fReceiverStream.Write(BuffersOut.lpvBuffer^,BuffersOut.dwBufferLength);
          inc (TotalRead,BuffersOut.dwBufferLength);
          Synchronize(triggerProgessEvent);
          while BuffersOut.dwBufferLength>0 do
          begin
            if Terminated then break;
            BuffersOut.dwBufferLength:=4096;
            //sleep(10);

            while (not InternetReadFileEx(fRequest.hAsyncHandle,pBuffersOut,IRF_NO_WAIT,fContext))do
            begin
              if terminated then break;
              sleep(100);
              if (GetLastError<>ERROR_IO_PENDING) then
                      RaiseLastAPIError;

            end;
            fRequest.fReceiverStream.Write(BuffersOut.lpvBuffer^,BuffersOut.dwBufferLength);
            inc (TotalRead,BuffersOut.dwBufferLength);
            Synchronize(triggerProgessEvent);

          end;

          TotalRead:=progressMax;
          Synchronize(triggerProgessEvent);

        finally
          freemem(BuffersOut.lpvBuffer,4096);

          fRequest.fAsyncStatus:=asFinished;
        end;

      end
      else
        fRequest.fAsyncStatus:=asCancelled;
    finally
      fRequest.AsyncReader:=nil;
      fRequest.ApiInterface.UnregisterCallBack(fRequest.pCallbackContext.CallbackID,fRequest.Connection.hSession);
      fRequest.ApiInterface.InternalInternetCloseHandle(fRequest.hAsyncHandle);
    end;

end;


{***********************************************************************************************************************}
{************************************** TInternetHTTPRequest Class Implementation ***********************************}
{***********************************************************************************************************************}



{TInternetHTTPRequest}


{-----------------------------------------------------------------------------------------------------------------------}
{------------------------------------ TInternetHTTPRequest Public Methods -------------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}


constructor TInternetHTTPRequest.Create(aOwner:TComponent);
begin
  inherited Create(aOwner);

  fAcceptTypes    := TStringList.Create;
  fhdrEchoHeaders := TStringList.Create;
  fhdrRawHeaders  := TStringList.Create;
  fhdqRawHeaders  := TStringList.Create;
  fhdrCookies     := TStringList.Create;
  // Tune Default Properties.
  fScheme:=isHTTP;
  fVersion.dwMajorVersion:=1;
  fVersion.dwMinorVersion:=1;
  {AcceptTypes.Add('text/*');
  AcceptTypes.Add('message/*');
  AcceptTypes.Add('multipart/*');
  AcceptTypes.Add('application/*');
  AcceptTypes.Add('image/*');
  AcceptTypes.Add('audio/*');
  AcceptTypes.Add('video/*');
  AcceptTypes.Add('model/*');
  }
  AcceptTypes.Add('image/gif');
  AcceptTypes.Add('image/x-xbitmap');
  AcceptTypes.Add('image/jpeg');
  AcceptTypes.Add('image/pjpeg');
  AcceptTypes.Add('application/x-shockwave-flash');
  AcceptTypes.Add('application/vnd.ms-powerpoint');
  AcceptTypes.Add('application/vnd.ms-excel');
  AcceptTypes.Add('application/msword');
  AcceptTypes.Add('*/*');
  Method:=hmGET;

  // Tune default options.
  // Set Default Header values.
end;

destructor  TInternetHTTPRequest.Destroy;
begin
  //if Connected then
  //  Disconnect;
  fAcceptTypes.Free;
  fhdrEchoHeaders.Free;
  fhdqRawHeaders.Free;
  fhdrRawHeaders.Free;
  fhdrCookies.free;
  inherited destroy;
end;
procedure TInternetHTTPRequest.OpenRequest;
var
  sVersion:string;
  sMethod:String;
  res:HINTERNET;
begin
  if assigned(Connection) then
  begin
    if not Connection.Connected then
      Connection.Connect;
  end
  else
    raise exception.create(sExceptionConnectionExpected);
  sVersion:= 'HTTP/'+inttostr(Version.dwMajorVersion)+'.'+inttostr(Version.dwMinorVersion);
  Case Method of
    hmGET    : sMethod := 'GET';
    hmHEAD   : sMethod := 'HEAD';
    hmPOST   : sMethod := 'POST';
    hmPUT    : sMethod := 'PUT';
    hmDELETE : sMethod := 'DELETE';
    hmTRACE  : sMethod := 'TRACE';
    hmCONNECT: sMethod := 'CONNECT';
    else
               sMethod := 'GET';
  end;

  //res:=ApiInterface.InternalHttpOpenRequest(hConnection,sMethod,ObjectName+ExtraInfo,sVersion,Referrer,AcceptTypes,getApiHttpFlags, dword(WindowHandle));

  res:=ApiInterface.InternalHttpOpenRequest(hConnection,sMethod,ObjectName+ExtraInfo,sVersion,Referrer,AcceptTypes,getApiHttpFlags, dword(pCallbackContext));
  if not assigned(res) then
    RaiseLastAPIError;
  setHandle(res);
  //clearHeaderBuffers;
  flashHeaderBuffers;
end;
{
procedure TInternetHTTPRequest.Connect;
var
  sVersion:string;
  sMethod:String;
  res:HINTERNET;
begin
  inherited Connect;
  sVersion:= 'HTTP/'+inttostr(Version.dwMajorVersion)+'.'+inttostr(Version.dwMinorVersion);
  Case Method of
    hmGET    : sMethod := 'GET';
    hmHEAD   : sMethod := 'HEAD';
    hmPOST   : sMethod := 'POST';
    hmPUT    : sMethod := 'PUT';
    hmDELETE : sMethod := 'DELETE';
    hmTRACE  : sMethod := 'TRACE';
    hmCONNECT: sMethod := 'CONNECT';
    else
               sMethod := 'GET';
  end;

  res:=ApiInterface.InternalHttpOpenRequest(hConnection,sMethod,ObjectName+ExtraInfo,sVersion,Referrer,AcceptTypes,getApiHttpFlags, dword(WindowHandle));
  if not assigned(res) then
    RaiseLastAPIError;
  setHttpHandle(res);
  //clearHeaderBuffers;
  flashHeaderBuffers;
end;
}
procedure TInternetHTTPRequest.CloseRequest;

begin
  try
    if assigned(AsyncReader) then
    begin
      CancelAsyncRequest;
      while  AsyncStatus<>asCancelled do
      begin
        sleep(10);
        //Application.ProcessMessages;
      end;
    end;
    CbBrokerbusy:=false;
    ApiInterface.InternalInternetCloseHandle(hRequest);
  finally
    setHandle(nil);
  end;
end;
{procedure TInternetHTTPRequest.Disconnect;
begin
  try
    ApiInterface.InternalInternetCloseHandle(hHttpRequest);
  finally
    setHttpHandle(nil);
    inherited Disconnect;
  end;
end;
}
// Parses URL and does all required tasks to access web resources in one way.
{procedure TInternetHTTPRequest.Open(ReceiveStream:TStream);
begin
  if not Connected then
    Connect;
  try
    SendRequest(ReceiveStream);
  finally
   // Disconnect;
  end;
end;
}
procedure TInternetHTTPRequest.SendRequest(ReceiveStream:TStream);
var
  dwNumberOfBytesToRead:dword;
  dwNumberofBytesRead:dword;
  nCounter:dword;
  buffer:pchar;
  res:boolean;
  pPostData:pchar;
  dwPostDataLength:dword;
  TotalRead:dword;
  progress,progressMax:dword;
  elapsedTime,estimatedTime:TDatetime;
  Speed:extended;
  SpeedUnit:string;
  //fs:TFileStream;
  //pFile:pchar;
  s:string;



 // fSize:integer;
  procedure triggerProgessEvent;
  begin
    progress:=TotalRead;
    if progress>progressMax then
      progress:=progressMax;
    doOnProgress(hRequest,progress,progressMax,INTERNET_STATUS_DOWNLOADING,'Downloading content',elapsedTime,estimatedTime,Speed,SpeedUnit);
  end;
begin

  ReceiveStream.Size:=0;
  setReceiverStream(ReceiveStream);
  nCounter:=0;
  TotalRead:=0;
  if opCookieHandling=chNative then
  begin
    Connection.getCookies(url,s);
    hdqCookie:=s;
  end;
  progressMax:=fDocSize;
  if assigned(UploadData) then
  begin
    AddRequestHeader(HTTP_QUERY_CONTENT_TYPE,'');//first clear if exist an old value...
    if not AddRequestHeader(HTTP_QUERY_CONTENT_TYPE,PostEncType) then
          RaiseLastAPIError;
    pPostData:=UploadData;
    dwPostDataLength:=UploadDataSize;
  end
  else
  begin
    pPostData:=nil;
    dwPostDataLength:=0;
  end;
  res:=false;
  if not Connection.Session.Asynchronous then
  repeat
    if not Connection.Session.Asynchronous then
      res:=(ApiInterface.InternalHttpSendRequest(hRequest,nil,0,pPostData,dwPostDataLength));
      //res:=(ApiInterface.InternalHttpSendRequest(hRequest,nil,0,nil,0))
      //res:=(ApiInterface.InternalHttpSendRequest(hRequest,pPostdata,dwPostDataLength,nil,0))
    if not res then
    begin
      if (GetLastError<> ERROR_IO_PENDING) then
        RaiseLastAPIError;
       inc(nCounter);
       sleep(10);
       if (nCounter=200) then
         RaiseLastAPIError;
    end;
  until res;
  if Connection.Session.Asynchronous then
  begin
    hAsyncHandle:=nil;
    fCanAsyncRead:=false;
    AsyncReader:=TInternetDataReader.create(self,dword(WindowHandle));
    AsyncReader.OnTerminate:=doOnReaderTerminate;
    AsyncReader.FreeOnTerminate:=true;
    AsyncReader.Resume;

  end;
  if not Connection.Session.Asynchronous then
  begin

    if opCookieHandling=chNative then
      Connection.setCookies(URL,hdrCookies);
    //if not ApiInterface.InternalHttpSendRequest(hHttpRequest,'',pchar(PostData),length(PostData)+1) then
    //  RaiseLastAPIError;
    dwNumberofBytesRead:=1;
    while dwNumberofBytesRead>0 do
    begin
      while dwNumberOfBytesToRead=0 do
      begin
        while (not ApiInterface.InternalInternetQueryDataAvailable(hRequest,dwNumberOfBytesToRead,0,0)) and (GetLastError= ERROR_IO_PENDING) do
        begin
          inc(nCounter);
           //Application.ProcessMessages;
           sleep(10);

          if (nCounter=2000) then
             break;
        end;
        if (not ApiInterface.InternalInternetQueryDataAvailable(hRequest,dwNumberOfBytesToRead,0,0)) and (GetLastError<> ERROR_IO_PENDING) then
          RaiseLastAPIError;
        if dwNumberOfBytesToRead=0 then
          break;
      end;
      dwNumberofBytesRead:=0;
      if dwNumberOfBytesToRead>0 then
      begin
        if progressMax=0 then
        begin
          progressMax:=hdrContentLength;
          if progressMax=0 then
            progressMax:=c_default_document_size;
          triggerProgessEvent;
        end;
        if dwNumberOfBytesToRead>4096 then
          dwNumberOfBytesToRead:=4096;
        {if fRedirected then
        begin
          fRedirected := false;
          exit;
        end;
        }
        getMem(buffer,dwNumberOfBytesToRead);
        try
          if not ApiInterface.InternalInternetReadFile(hRequest,buffer,dwNumberOfBytesToRead,dwNumberofBytesRead) then
          begin
            RaiseLastAPIError
          end
          else
          begin
            inc(TotalRead,dwNumberofBytesRead);
            fReceiverStream.Write(buffer^,dwNumberofBytesRead);
          end;
          triggerProgessEvent;
        finally
         dwNumberOfBytesToRead:=0;
         freeMem(buffer,dwNumberOfBytesToRead);
        end;
      end;
    end;

    TotalRead:=progressMax;
    triggerProgessEvent;

    if assigned(fOnloaded) then
      fOnLoaded(Self,hRequest,fReceiverStream);
  end;
  FreeMem(UploadData);
  UploadData:=nil;
  UploadDataSize:=0;

end;

{-----------------------------------------------------------------------------------------------------------------------}
{----------------------------------- TInternetHTTPRequest Protected Methods -----------------------------------------}
{-----------------------------------------------------------------------------------------------------------------------}


procedure TInternetHTTPRequest.doOnIntermediateResponse(hInet:HINTERNET; dwContext:DWORD;                        //  Triggered when an intermediate (100 level) status code Received  from the server.  [ API_FLAG: INTERNET_STATUS_INTERMEDIATE_RESPONSE]
                                       ResponseCode:dword);
begin
  fDocSize:=hdrContentLength;
  if fDocSize=0 then
    fDocSize:=c_default_document_size;
  fLastResponseCode:=ResponseCode;
  inherited;
end;
procedure TInternetHTTPRequest.doOnResponseReceived(hInet:HINTERNET; dwContext:DWORD;pResLength: pdword);//  Triggered when a response successfully received from the server.                   [ API FLAG: INTERNET_STATUS_RESPONSE_RECEIVED    ]
begin
(*
  fDocSize:=hdrContentLength;
  if fDocSize=0 then
    fDocSize:=c_default_document_size;
  fLastResponseCode:=hdrStatusCode;
  *)
  inherited;
end;
procedure TInternetHTTPRequest.doOnRedirect(hInet:HINTERNET; dwContext:DWORD; newURL :pchar);
var
  Cancel:boolean;
  oldURL:string;
begin
  Connection.Redirecting:=true;
  fRedirected :=True;
  fNewURL:=newURL;
  if assigned(fOnRedirect) then
      fOnRedirect(Self,hRequest,oldURL,String(newUrl),Cancel);

  if assigned(AsyncReader) then
    exit;//will be handled in the reader thread!
  try
    oldURL:=url;
    CloseRequest;
    url:=string(NewUrl);
    if cancel then
    begin
      CloseRequest;
      abort;
    end
    else
    begin
      //CloseRequest;
      CbBrokerbusy:=false;
      OpenRequest;
      UploadData:=nil;
      UploadDataSize:=0;
      SendRequest(fReceiverStream);
    end;
  finally
    Connection.Redirecting:=false;
  end;
end;
procedure TInternetHTTPRequest.setScheme(p:TInternetSchemes);
begin
  inherited;
  if csLoading in ComponentState then
  begin
    if assigned(Connection) and (p in [isHTTP, isHTTPS]) then
     Connection.scheme:=p;
    exit;
  end;
  if assigned(Connection) and (not (p in [isHTTP, isHTTPS])) then
    Raise EInvalidScheme.Create(format(sExceptionInvalidScheme,['http: , https:']));

end;
procedure TInternetHTTPRequest.setServer(p:string);
begin
  inherited;
end;
procedure TInternetHTTPRequest.setConnection(p:TCustomInternetConnection);
begin
  inherited;
  if Assigned(Connection) then
  begin
    Connection.Service:=ictHTTP;
    if not (Scheme  in [isHTTP, isHTTPS]) then
      Scheme:=isHTTP;
  end;
end;
function  TInternetHTTPRequest.gethConnection:pointer;
begin
  if assigned(Connection) then
    result:=Connection.hConnection
  else
    result:=nil;
end;
function  TInternetHTTPRequest.getMethod:TInternetHttpMethods;
begin
  result:= fMethod;
end;

procedure TInternetHTTPRequest.setMethod(p:TInternetHttpMethods);
begin
  //if Connected and (not Redirecting) then
  //  raise Exception.Create(format(sExceptionConnectionActive,['"Method (Verb)"']));
  fMethod:=p;
end;


function  TInternetHTTPRequest.getVersion:HTTP_VERSION_INFO;
begin
  result:=fVersion;
end;

procedure TInternetHTTPRequest.setVersion(p:HTTP_VERSION_INFO);
begin
  //if Connected and (not Redirecting) then
  //  raise Exception.Create(format(sExceptionConnectionActive,['"Version"']));
  fVersion:=p;
end;

function  TInternetHTTPRequest.getReferrer:string;
begin
  result:=fReferrer;
end;

procedure TInternetHTTPRequest.setReferrer(p:string);
begin
  //if Connected and (not Redirecting) then
  //  raise Exception.Create(format(sExceptionConnectionActive,['"Referrer"']));
  fReferrer:=p;
end;

function  TInternetHTTPRequest.getAcceptTypes:TStrings;
begin
  result:=fAcceptTypes;
end;

procedure TInternetHTTPRequest.setAcceptTypes(p:TStrings);
begin
  //if Connected then
  //  raise Exception.Create(format(sExceptionConnectionActive,['"AcceptTypes"']));
  fAcceptTypes.assign(p);
end;

function  TInternetHTTPRequest.getHttpContext:pointer;
begin
  //result:=fHttpContext;
  result:=pCallbackContext.pAppData;
end;

procedure TInternetHTTPRequest.setHttpContext(p:pointer);
begin
//  fHttpContext:=p;
  pCallbackContext.pAppData:=p
  //if connected then call api to make api informed for the new context value.
//  if Connected then
//    ApiOptions.CONTEXT_VALUE:=p;
end;

function  TInternetHTTPRequest.getApiHttpFlags:dword;
var
  OldNoCookieFlag:boolean;
  NewNoCookieFlag:boolean;
begin
  OldNoCookieFlag:=(fHttpFlags and INTERNET_FLAG_NO_UI)>0;
  NewNoCookieFlag:= (Connection.opCookieHandling=chNative) or (opCookieHandling=chNone);
  if OldNoCookieFlag<>NewNoCookieFlag then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_COOKIES;
  end;
  result:=fHttpFlags;
end;

function  TInternetHTTPRequest.AddRequestHeader(API_FLAG: dword; headerValue:string):boolean;
var
  headerCommand:THTTPHeaderCommands;
  t:THTTPHeaderCommands;
  header:string;
  flag:dword;
begin
  headerCommand:=hcUnknown;
  for t:=low(THTTPHeaderCommands) to high(THTTPHeaderCommands) do
  begin
    if c_HTTPHeaderCommandWINInetMapping[t]=API_FLAG then
    begin
      headerCommand:=t;
      break;
    end;
  end;
  if HeaderValue='' then
    flag:=HTTP_ADDREQ_FLAG_REPLACE
  else
    flag:=HTTP_ADDREQ_FLAG_ADD;
  if headerCommand<>hcUnknown then
  begin
    header:=c_HTTPHeaderCommandIds[headerCommand]+': '+headerValue;
    result:=ApiInterface.InternalHttpAddRequestHeaders(hRequest,Header,flag);
  end
  else
    Raise Exception.Create(format(sExceptionUnknownHttpHeaderCommand,[API_FLAG]));
end;

procedure TInternetHTTPRequest.GetRequestHeaderProp(API_FLAG: dword; var FuncResult:string;pInternalPropVar:pointer);
var
  Index:dword;
  s:string;
begin
  Index:=0;
  FuncResult:='';
  if not Active then
  begin
    if assigned(pInternalPropVar) then
      FuncResult:=string(pInternalPropVar^)
    else
      FuncResult:=sMsgNotConnected;
  end
  else
  repeat
    if ApiInterface.InternalHttpQueryInfo(hRequest,API_FLAG or HTTP_QUERY_FLAG_REQUEST_HEADERS,Funcresult,Index) then
    begin
      FuncResult:=FuncResult+s;
      if Index<>ERROR_HTTP_HEADER_NOT_FOUND then
        FuncResult:=FuncResult+#$D+#$A;
    end
    else
    begin
      if GetLastError<>ERROR_HTTP_HEADER_NOT_FOUND then
        RaiseLastAPIError
      else
      begin
        //if (index<>ERROR_HTTP_HEADER_NOT_FOUND) then
        //  FuncResult:=FuncResult+s;
        break;
      end;
    end;
  until (Index=ERROR_HTTP_HEADER_NOT_FOUND) or (Index=0);
end;

procedure TInternetHTTPRequest.GetResponseHeaderProp(API_FLAG: dword; var FuncResult:string;pInternalPropVar:pointer);
var
  Index:dword;
  s:string;
begin
  Index:=0;
  FuncResult:='';
  if not Active then
  begin
    if assigned(pInternalPropVar) then
      FuncResult:=string(pInternalPropVar^)
    else
      FuncResult:=sMsgNotConnected;
  end
  else
  repeat
    if ApiInterface.InternalHttpQueryInfo(hRequest,API_FLAG,s,Index) then
    begin
      FuncResult:=FuncResult+s;
      if Index<>ERROR_HTTP_HEADER_NOT_FOUND then
        FuncResult:=FuncResult+#$D+#$A;
    end
    else
    begin
      if GetLastError<>ERROR_HTTP_HEADER_NOT_FOUND then
        RaiseLastAPIError
      else
      begin
        //if (index<>ERROR_HTTP_HEADER_NOT_FOUND) then
        //  FuncResult:=FuncResult+s;
        break;
      end;
    end;
  until (Index=ERROR_HTTP_HEADER_NOT_FOUND) or (Index=0);
end;

procedure TInternetHTTPRequest.GetResponseIntHeaderProp(API_FLAG: dword; var FuncResult:dword;pInternalPropVar:pointer);
var Index:dword;
begin
  Index:=0;
  if not Active then
  begin
    if assigned(pInternalPropVar) then
      FuncResult:=pdword(pInternalPropVar)^
    else
      FuncResult:=0;
  end
  else
  if not ApiInterface.InternalHttpQueryInfoAsInt(hRequest,API_FLAG or HTTP_QUERY_FLAG_NUMBER ,Funcresult,Index) then
    if GetLastError<>ERROR_HTTP_HEADER_NOT_FOUND then
      RaiseLastAPIError
    else
      FuncResult:=0;
end;
procedure TInternetHTTPRequest.SetHeaderProp(API_FLAG: dword; var InternalPropVar:string; NewValue:string);
begin
  if not Active then
    InternalPropVar:=NewValue
  else
  begin
    AddRequestHeader(API_FLAG,''); //clear first;
    if AddRequestHeader(API_FLAG,NewValue) then
      InternalPropVar:=NewValue
    else
    if GetLastError<>ERROR_HTTP_HEADER_NOT_FOUND then
      RaiseLastAPIError;
  end;
end;
function  TInternetHTTPRequest.getPostData:string;
begin
 result:=fPostData;
end;
procedure TInternetHTTPRequest.setPostData(p:string);
begin
  fPostData:=p;
end;
procedure TInternetHTTPRequest.clearHeaderBuffers;
begin

  fhdqAccepTypes:='';
  fhdqAcceptCharSet:='';
  fhdqAcceptEncoding:='';
  fhdqAcceptLanguage:='';
  fhdqAcceptRanges:='';
  fhdqAuthorization:='';
  fhdqExpect:='';
  fhdqIfMatch:='';
  fhdqIfModifiedSince:='';
  fhdqIfNoneMatch:='';
  fhdqIfRange:='';
  fhdqIfUnmodifiedSince:='';
  fhdqMaxForwards:='';
  fhdqPragma:='';
  fhdqProxyAuthorization:='';
  fhdqProxyConnection:='';
  fhdqRange:='';
  fhdqRetryAfter:='';
  fhdqCookie:='';
  fhdqTransferEncoding:='';
  fhdqUnlessModifiedSince:='';
  fhdqUserAgent:='';
  fhdqVia:='';

  set_hdqAcceptTypes('');
  set_hdqAcceptCharSet('');
  set_hdqAcceptEncoding('');
  set_hdqAcceptLanguage('');
    set_hdqAcceptRanges('');
    set_hdqAuthorization('');
    set_hdqExpect('');
    set_hdqIfMatch('');
    set_hdqIfModifiedSince('');
    set_hdqIfNoneMatch('');
    set_hdqIfRange('');
    set_hdqIfUnmodifiedSince('');
    set_hdqMaxForwards('');
    set_hdqPragma('');
    set_hdqProxyAuthorization('');
    set_hdqProxyConnection('');
  set_hdqRange('');
  set_hdqRetryAfter('');
  set_hdqCookie('');
  set_hdqTransferEncoding('');
  set_hdqUnlessModifiedSince('');
  set_hdqUserAgent('');
  set_hdqVia('');
end;
procedure TInternetHTTPRequest.flashHeaderBuffers;
begin
  if fhdqAccepTypes<>''  then
    set_hdqAcceptTypes(fhdqAccepTypes);
  if fhdqAcceptCharSet<>'' then
    set_hdqAcceptCharSet(fhdqAcceptCharSet);
  if fhdqAcceptEncoding<>'' then
    set_hdqAcceptEncoding(fhdqAcceptEncoding);
  if fhdqAcceptLanguage<>'' then
    set_hdqAcceptLanguage(fhdqAcceptLanguage);
  if fhdqAcceptRanges<>'' then
    set_hdqAcceptRanges(fhdqAcceptRanges);
  if fhdqAuthorization<>'' then
    set_hdqAuthorization(fhdqAuthorization);
  if fhdqExpect<>'' then
    set_hdqExpect(fhdqExpect);
  if fhdqIfMatch<>'' then
    set_hdqIfMatch(fhdqIfMatch);
  if fhdqIfModifiedSince<>'' then
    set_hdqIfModifiedSince(fhdqIfModifiedSince);
  if fhdqIfNoneMatch<>'' then
    set_hdqIfNoneMatch(fhdqIfNoneMatch);
  if fhdqIfRange<>'' then
    set_hdqIfRange(fhdqIfRange);
  if fhdqIfUnmodifiedSince<>'' then
    set_hdqIfUnmodifiedSince(fhdqIfUnmodifiedSince);
  if fhdqMaxForwards<>'' then
    set_hdqMaxForwards(fhdqMaxForwards);
  if fhdqPragma<>'' then
    set_hdqPragma(fhdqPragma);
  if fhdqProxyAuthorization<>'' then
    set_hdqProxyAuthorization(fhdqProxyAuthorization);
  if fhdqProxyConnection<>'' then
    set_hdqProxyConnection(fhdqProxyConnection);
  if fhdqRange<>'' then
    set_hdqRange(fhdqRange);
  if fhdqRetryAfter<>'' then
    set_hdqRetryAfter(fhdqRetryAfter);
  if fhdqCookie<>'' then
    set_hdqCookie(fhdqCookie);
  if fhdqTransferEncoding<>'' then
    set_hdqTransferEncoding(fhdqTransferEncoding);
  if fhdqUnlessModifiedSince<>'' then
    set_hdqUnlessModifiedSince(fhdqUnlessModifiedSince);
  if fhdqUserAgent<>'' then
    set_hdqUserAgent(fhdqUserAgent);
  if fhdqVia<>'' then
    set_hdqVia(fhdqVia);
end;
procedure TInternetHTTPRequest.setReceiverStream(aStream:TStream);
begin
  fReceiverStream:=aStream;
end;
function  TInternetHTTPRequest.getCookieURL:string;
var
  URLComponents:TURL_Components;
  function CrackUserName(s:string):string;
  begin
    result:=StringReplace(s,' ','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'?','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'%','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'#','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,':','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'@','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'/','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'\','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'=','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'+','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,',','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'.','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,';','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'`','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'#','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'$','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'~','_',[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(result,'*','_',[rfReplaceAll, rfIgnoreCase]);
  end;
begin

  URLComponents.Scheme:=c_InternetSchemeIds[scheme];
  URLComponents.nScheme:=scheme;
  if connection.session.CurrentUser<>'' then
    URLComponents.UrlPath:='/'+CrackUserName(connection.session.CurrentUser)+ ObjectName
  else
    URLComponents.UrlPath:=ObjectName;
  URLComponents.HostName:=Server;
  URLComponents.nPort:=Port;
  URLComponents.pad:=0;
  URLComponents.UserName:=UserName;
  URLComponents.Password:=Password;

  URLComponents.ExtraInfo:=ExtraInfo;
  if not ApiInterface.InternalInternetCreateUrl(URLComponents,[icoESCAPE,icoUSERNAME],result) then
    RaiseLastAPIError;

end;


{OPTIONS [FLAGS]}

// [ Set API FLAG: INTERNET_FLAG_CACHE_IF_NET_FAIL        ]
function  TInternetHTTPRequest.get_opCacheIfNetFail:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_CACHE_IF_NET_FAIL)>0;
end;

// [ Get API FLAG: INTERNET_FLAG_CACHE_IF_NET_FAIL        ]
procedure TInternetHTTPRequest.set_opCacheIfNetFail(p:boolean);
begin
  if opCacheIfNetFail<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_CACHE_IF_NET_FAIL;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_HYPERLINK                ]
function  TInternetHTTPRequest.get_opHyperlink:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_HYPERLINK)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_HYPERLINK                ]
procedure TInternetHTTPRequest.set_opHyperlink(p:boolean);
begin
  if opHyperlink<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_HYPERLINK;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_IGNORE_CERT_CN_INVALID   ]
function  TInternetHTTPRequest.get_opIgnoreCertCNInvalid:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_IGNORE_CERT_CN_INVALID)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_IGNORE_CERT_CN_INVALID   ]
procedure TInternetHTTPRequest.set_opIgnoreCertCNInvalid(p:boolean);
begin
  if opIgnoreCertCNInvalid<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_IGNORE_CERT_DATE_INVALID ]
function  TInternetHTTPRequest.get_opIgnoreCertDateInvalid:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_IGNORE_CERT_DATE_INVALID)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_IGNORE_CERT_DATE_INVALID ]
procedure TInternetHTTPRequest.set_opIgnoreCertDateInvalid(p:boolean);
begin
  if opIgnoreCertDateInvalid<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  ]
function  TInternetHTTPRequest.get_opIgnoreRedirectToHTTP:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP  ]
procedure TInternetHTTPRequest.set_opIgnoreRedirectToHTTP(p:boolean);
begin
  if opIgnoreRedirectToHTTP<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS ]
function  TInternetHTTPRequest.get_opIgnoreRedirectToHTTPS:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS ]
procedure TInternetHTTPRequest.set_opIgnoreRedirectToHTTPS(p:boolean);
begin
  if opIgnoreRedirectToHTTPS<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_KEEP_CONNECTION          ]
function  TInternetHTTPRequest.get_opKeepConnection:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_KEEP_CONNECTION)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_KEEP_CONNECTION          ]
procedure TInternetHTTPRequest.set_opKeepConnection(p:boolean);
begin
  if opKeepConnection<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_KEEP_CONNECTION;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_NEED_FILE                ]
function  TInternetHTTPRequest.get_opNeedFile:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_NEED_FILE)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_NEED_FILE                ]
procedure TInternetHTTPRequest.set_opNeedFile(p:boolean);
begin
  if opNeedFile<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NEED_FILE;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_NO_AUTH                  ]
function  TInternetHTTPRequest.get_opNoAutoAuth:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_NO_AUTH)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_NO_AUTH                  ]
procedure TInternetHTTPRequest.set_opNoAutoAuth(p:boolean);
begin
  if opNoAutoAuth<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_AUTH;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_NO_AUTO_REDIRECT         ]
function  TInternetHTTPRequest.get_opNoAutoRedirect:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_NO_AUTO_REDIRECT)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_NO_AUTO_REDIRECT         ]
procedure TInternetHTTPRequest.set_opNoAutoRedirect(p:boolean);
begin
  if opNoAutoRedirect<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_AUTO_REDIRECT;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_NO_CACHE_WRITE           ]
function  TInternetHTTPRequest.get_opNoCacheWrite:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_NO_CACHE_WRITE)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_NO_CACHE_WRITE           ]
procedure TInternetHTTPRequest.set_opNoCacheWrite(p:boolean);
begin
  if opNoCacheWrite<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_CACHE_WRITE;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_NO_COOKIES       ]
function  TInternetHTTPRequest.get_opCookieHandling:THTTPCookieHandlingTypes;
begin
  {result:=fCookieHandling;}
  if assigned(Connection) then
    result:=Connection.opCookieHandling
  else
    result:=chAPI;

end;

// [ Set API FLAG: INTERNET_FLAG_NO_COOKIES       ]
procedure TInternetHTTPRequest.set_opCookieHandling(p:THTTPCookieHandlingTypes);
{var
  OldNoCookieFlag:boolean;
  NewNoCookieFlag:boolean;}
begin
  if assigned(Connection) then
    Connection.opCookieHandling:=p;
  {OldNoCookieFlag:=(fHttpFlags and INTERNET_FLAG_NO_UI)>0;
  NewNoCookieFlag:= (p=chNative) or (p=chNone);
  if OldNoCookieFlag<>NewNoCookieFlag then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_COOKIES;
  end;
  fCookieHandling:=p;
  }
end;

// [ Get API FLAG: INTERNET_FLAG_NO_UI                    ]
function  TInternetHTTPRequest.get_opDisableCookieDialogbox:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_NO_UI)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_NO_UI                    ]
procedure TInternetHTTPRequest.set_opDisableCookieDialogbox(p:boolean);
begin
  if opDisableCookieDialogbox<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_NO_UI;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_PRAGMA_NOCACHE           ]
function  TInternetHTTPRequest.get_opForceProxyToReload:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_PRAGMA_NOCACHE)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_PRAGMA_NOCACHE           ]
procedure TInternetHTTPRequest.set_opForceProxyToReload(p:boolean);
begin
  if opForceProxyToReload<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_PRAGMA_NOCACHE;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_RELOAD                   ]
function  TInternetHTTPRequest.get_opForceReload:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_RELOAD)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_RELOAD                   ]
procedure TInternetHTTPRequest.set_opForceReload(p:boolean);
begin
  if opForceReload<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_RELOAD;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_RESYNCHRONIZE            ]
function  TInternetHTTPRequest.get_opResynchronize:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_RESYNCHRONIZE)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_RESYNCHRONIZE            ]
procedure TInternetHTTPRequest.set_opResynchronize(p:boolean);
begin
  if opResynchronize<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_RESYNCHRONIZE;
  end;
end;

// [ Get API FLAG: INTERNET_FLAG_SECURE                   ]
function  TInternetHTTPRequest.get_opSecure:boolean;
begin
  result:= (fHttpFlags and INTERNET_FLAG_SECURE)>0;
end;

// [ Set API FLAG: INTERNET_FLAG_SECURE                   ]
procedure TInternetHTTPRequest.set_opSecure(p:boolean);
begin
  if opSecure<>p then
  begin
    fHttpFlags := fHttpFlags xor INTERNET_FLAG_SECURE;
  end;
end;

{***************************************** REQUEST HEADER PROPERTY MANUPULATORS *************************************}

// [HTTP_QUERY_ACCEPT] : Retrieves the acceptable media types for the response.
function  TInternetHTTPRequest.get_hdqAcceptTypes:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_ACCEPT,result,@fhdqAccepTypes);
end;

// [HTTP_QUERY_ACCEPT] : Sets the acceptable media types for the response.
procedure TInternetHTTPRequest.set_hdqAcceptTypes(p:string);
begin
  SetHeaderProp(HTTP_QUERY_ACCEPT,fhdqAccepTypes,p);
end;

// [HTTP_QUERY_ACCEPT_CHARSET] : Retrieves the acceptable character sets for the response.
function  TInternetHTTPRequest.get_hdqAcceptCharSet:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_ACCEPT_CHARSET,result,@fhdqAcceptCharSet);
end;

// [HTTP_QUERY_ACCEPT_CHARSET] : Sets the acceptable character sets for the response.
procedure TInternetHTTPRequest.set_hdqAcceptCharSet(p:string);
begin
  SetHeaderProp(HTTP_QUERY_ACCEPT_CHARSET,fhdqAcceptCharSet,p);
end;

// [HTTP_QUERY_ACCEPT_ENCODING] : Retrieves the acceptable content-coding values for the response.
function  TInternetHTTPRequest.get_hdqAcceptEncoding:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_ACCEPT_ENCODING,result,@fhdqAcceptEncoding);
end;

// [HTTP_QUERY_ACCEPT_ENCODING] : Sets the acceptable content-coding values for the response.
procedure TInternetHTTPRequest.set_hdqAcceptEncoding(p:string);
begin
  SetHeaderProp(HTTP_QUERY_ACCEPT_ENCODING,fhdqAcceptEncoding,p);
end;

// [HTTP_QUERY_ACCEPT_LANGUAGE] : Retrieves the acceptable natural languages for the response.
function  TInternetHTTPRequest.get_hdqAcceptLanguage:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_ACCEPT_LANGUAGE,result,@fhdqAcceptLanguage);
end;

// [HTTP_QUERY_ACCEPT_LANGUAGE] : Sets the acceptable natural languages for the response.
procedure TInternetHTTPRequest.set_hdqAcceptLanguage(p:string);
begin
  SetHeaderProp(HTTP_QUERY_ACCEPT_LANGUAGE,fhdqAcceptLanguage,p);
end;

// [HTTP_QUERY_ACCEPT_RANGES] : Retrieves the types of range requests that are accepted for a resource.
function  TInternetHTTPRequest.get_hdqAcceptRanges:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_ACCEPT_RANGES,result,@fhdqAcceptRanges);
end;

// [HTTP_QUERY_ACCEPT_RANGES] : Sets the types of range requests that are accepted for a resource.
procedure TInternetHTTPRequest.set_hdqAcceptRanges(p:string);
begin
  SetHeaderProp(HTTP_QUERY_ACCEPT_RANGES,fhdqAcceptRanges,p);
end;

// [HTTP_QUERY_AUTHORIZATION] : Retrieves the authorization credentials used for a request.
function  TInternetHTTPRequest.get_hdqAuthorization:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_AUTHORIZATION,result,@fhdqAuthorization);
end;

// [HTTP_QUERY_AUTHORIZATION] : Sets the authorization credentials used for a request.
procedure TInternetHTTPRequest.set_hdqAuthorization(p:string);
begin
  SetHeaderProp(HTTP_QUERY_AUTHORIZATION,fhdqAuthorization,p);
end;

// [HTTP_QUERY_EXPECT] : Retrieves the Expect header, which indicates whether the client application should expect 100 series responses.
function  TInternetHTTPRequest.get_hdqExpect:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_EXPECT,result,@fhdqExpect);
end;

// [HTTP_QUERY_EXPECT] : Sets the Expect header, which indicates whether the client application should expect 100 series responses.
procedure TInternetHTTPRequest.set_hdqExpect(p:string);
begin
  SetHeaderProp(HTTP_QUERY_EXPECT,fhdqExpect,p);
end;

// [HTTP_QUERY_IF_MATCH] : Retrieves the contents of the If-Match request-header field.
function  TInternetHTTPRequest.get_hdqIfMatch:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_IF_MATCH,result,@fhdqIfMatch);
end;

// [HTTP_QUERY_IF_MATCH] : Sets the contents of the If-Match request-header field.
procedure TInternetHTTPRequest.set_hdqIfMatch(p:string);
begin
  SetHeaderProp(HTTP_QUERY_IF_MATCH,fhdqIfMatch,p);
end;

// [HTTP_QUERY_IF_MODIFIED_SINCE] : Retrieves the contents of the If-Modified-Since header.
function  TInternetHTTPRequest.get_hdqIfModifiedSince:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_IF_MODIFIED_SINCE,result,@fhdqIfModifiedSince);
end;

// [HTTP_QUERY_IF_MODIFIED_SINCE] : Sets the contents of the If-Modified-Since header.
procedure TInternetHTTPRequest.set_hdqIfModifiedSince(p:string);
begin
  SetHeaderProp(HTTP_QUERY_IF_NONE_MATCH,fhdqIfNoneMatch,p)
end;

// [HTTP_QUERY_IF_NONE_MATCH] : Retrieves the contents of the If-None-Match request-header field.
function  TInternetHTTPRequest.get_hdqIfNoneMatch:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_IF_NONE_MATCH,result,@fhdqIfNoneMatch);
end;

// [HTTP_QUERY_IF_NONE_MATCH] : Sets the contents of the If-None-Match request-header field.
procedure TInternetHTTPRequest.set_hdqIfNoneMatch(p:string);
begin
  SetHeaderProp(HTTP_QUERY_IF_NONE_MATCH,fhdqIfNoneMatch,p);
end;

// [HTTP_QUERY_IF_RANGE] : Retrieves the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
function  TInternetHTTPRequest.get_hdqIfRange:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_IF_RANGE,result,@fhdqIfRange);
end;

// [HTTP_QUERY_IF_RANGE] : Sets the contents of the If-Range request-header field. This header allows the client application to check if the entity related to a partial copy of the entity in the client application's cache has not been updated. If the entity has not been updated, send the parts that the client application is missing. If the entity has been updated, send the entire updated entity.
procedure TInternetHTTPRequest.set_hdqIfRange(p:string);
begin
  SetHeaderProp(HTTP_QUERY_IF_RANGE,fhdqIfRange,p);
end;

// [HTTP_QUERY_IF_UNMODIFIED_SINCE] : Retrieves the contents of the If-Unmodified-Since request-header field.
function  TInternetHTTPRequest.get_hdqIfUnmodifiedSince:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_IF_UNMODIFIED_SINCE,result,@fhdqIfUnmodifiedSince);
end;

// [HTTP_QUERY_IF_UNMODIFIED_SINCE] : Sets the contents of the If-Unmodified-Since request-header field.
procedure TInternetHTTPRequest.set_hdqIfUnmodifiedSince(p:string);
begin
  SetHeaderProp(HTTP_QUERY_IF_UNMODIFIED_SINCE,fhdqIfUnmodifiedSince,p);
end;

// [HTTP_QUERY_MAX_FORWARDS] : Retrieves the number of proxies or gateways that can forward the request to the next inbound server.
function  TInternetHTTPRequest.get_hdqMaxForwards:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_LOCATION,result,@fhdqMaxForwards);
end;

// [HTTP_QUERY_MAX_FORWARDS] : Sets the number of proxies or gateways that can forward the request to the next inbound server.
procedure TInternetHTTPRequest.set_hdqMaxForwards(p:string);
begin
  SetHeaderProp(HTTP_QUERY_MAX_FORWARDS,fhdqMaxForwards,p);
end;

// [HTTP_QUERY_PRAGMA] : Receives the implementation-specific directives that might apply to any recipient along the request/response chain.
function  TInternetHTTPRequest.get_hdqPragma:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_PRAGMA,result,@fhdqPragma);
end;

// [HTTP_QUERY_PRAGMA] : Sets the implementation-specific directives that might apply to any recipient along the request/response chain.
procedure TInternetHTTPRequest.set_hdqPragma(p:string);
begin
  SetHeaderProp(HTTP_QUERY_PRAGMA,fhdqPragma,p);
end;

// [HTTP_QUERY_PROXY_AUTHORIZATION] : Retrieves the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
function  TInternetHTTPRequest.get_hdqProxyAuthorization:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_PROXY_AUTHENTICATE,result,@fhdqProxyAuthorization);
end;

// [HTTP_QUERY_PROXY_AUTHORIZATION] : Sets the header that is used to identify the user to a proxy that requires authentication. This header can only be retrieved before the request is sent to the server.
procedure TInternetHTTPRequest.set_hdqProxyAuthorization(p:string);
begin
  SetHeaderProp(HTTP_QUERY_PROXY_AUTHORIZATION,fhdqProxyAuthorization,p);
end;

// [HTTP_QUERY_PROXY_CONNECTION] : Retrieves the Proxy-Connection header.
function  TInternetHTTPRequest.get_hdqProxyConnection:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_PROXY_CONNECTION,result,@fhdqProxyConnection);
end;

// [HTTP_QUERY_PROXY_CONNECTION] : Sets the Proxy-Connection header.
procedure TInternetHTTPRequest.set_hdqProxyConnection(p:string);
begin
  SetHeaderProp(HTTP_QUERY_PROXY_CONNECTION,fhdqProxyConnection,p);
end;

// [HTTP_QUERY_RANGE] : Retrieves the byte range of an entity.
function  TInternetHTTPRequest.get_hdqRange:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_PUBLIC,result,@fhdqRange);
end;

// [HTTP_QUERY_RANGE] : Sets the byte range of an entity.
procedure TInternetHTTPRequest.set_hdqRange(p:string);
begin
  SetHeaderProp(HTTP_QUERY_RANGE,fhdqRange,p);
end;

// [HTTP_QUERY_RAW_HEADERS_CRLF] : Receives all the headers associated by the request. Each header is separated by a carriage return/line feed (CR/LF) sequence.
function  TInternetHTTPRequest.get_hdqRawHeaders:TStrings;
var s:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_RAW_HEADERS_CRLF,s,nil);
  fhdqRawHeaders.Text:=s;
  result:=fhdqRawHeaders;
end;


// [HTTP_QUERY_REQUEST_METHOD] : Receives the HTTP verb that is being used in the request, typically GET or POST.
function  TInternetHTTPRequest.get_hdqRequestMethod:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_REQUEST_METHOD,result,nil);
end;

// [HTTP_QUERY_RETRY_AFTER] : Retrieves the amount of time the service is expected to be unavailable.
function  TInternetHTTPRequest.get_hdqRetryAfter:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_RETRY_AFTER,result,@fhdqRetryAfter);
end;

// [HTTP_QUERY_RETRY_AFTER] : Sets the amount of time the service is expected to be unavailable.
procedure TInternetHTTPRequest.set_hdqRetryAfter(p:string);
begin
  SetHeaderProp(HTTP_QUERY_RETRY_AFTER,fhdqRetryAfter,p);
end;

// [HTTP_QUERY_SET_COOKIE] : Receives the value of the cookie set for the request.
function  TInternetHTTPRequest.get_hdqCookie:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_COOKIE,result,@fhdqCookie);
end;

// [HTTP_QUERY_SET_COOKIE] : Sets the value of the cookie set for the request.
procedure TInternetHTTPRequest.set_hdqCookie(p:string);
begin
  if p<>'' then
    SetHeaderProp(HTTP_QUERY_COOKIE,fhdqCookie,p);
end;

// [HTTP_QUERY_TRANSFER_ENCODING] : Retrieves the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
function  TInternetHTTPRequest.get_hdqTransferEncoding:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_TRANSFER_ENCODING,result,@fhdqTransferEncoding);
end;

// [HTTP_QUERY_TRANSFER_ENCODING] : Sets the type of transformation that has been applied to the message body so it can be safely transferred between the sender and recipient.
procedure TInternetHTTPRequest.set_hdqTransferEncoding(p:string);
begin
  SetHeaderProp(HTTP_QUERY_TRANSFER_ENCODING,fhdqTransferEncoding,p);
end;

// [HTTP_QUERY_UNLESS_MODIFIED_SINCE] : Retrieves the Unless-Modified-Since header.
function  TInternetHTTPRequest.get_hdqUnlessModifiedSince:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_UNLESS_MODIFIED_SINCE,result,@fhdqUnlessModifiedSince);
end;

// [HTTP_QUERY_UNLESS_MODIFIED_SINCE] : Sets the Unless-Modified-Since header.
procedure TInternetHTTPRequest.set_hdqUnlessModifiedSince(p:string);
begin
  SetHeaderProp(HTTP_QUERY_UNLESS_MODIFIED_SINCE,fhdqUnlessModifiedSince,p);
end;

// [HTTP_QUERY_USER_AGENT] : Retrieves information about the user agent that made the request.
function  TInternetHTTPRequest.get_hdqUserAgent:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_USER_AGENT,result,@fhdqUserAgent);
end;

// [HTTP_QUERY_USER_AGENT] : Sets information about the user agent that made the request.
procedure TInternetHTTPRequest.set_hdqUserAgent(p:string);
begin
  SetHeaderProp(HTTP_QUERY_USER_AGENT,fhdqUserAgent,p);
end;

// [HTTP_QUERY_VIA] : Retrieves the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
function  TInternetHTTPRequest.get_hdqVia:string;
begin
  GetRequestHeaderProp(HTTP_QUERY_VIA,result,@fhdqVia);
end;

// [HTTP_QUERY_VIA] : Sets the intermediate protocols and recipients between the user agent and the server on requests, and between the origin server and the client on responses.
procedure TInternetHTTPRequest.set_hdqVia(p:string);
begin
  SetHeaderProp(HTTP_QUERY_VIA,fhdqVia,p);
end;


{***************************************** RESPONSE HEADER PROPERTY MANUPULATORS *************************************}

// [HTTP_QUERY_AGE] : Retrieves the Age response-header field, which contains the sender's estimate of the amount of time since the response was generated at the origin server.
function  TInternetHTTPRequest.get_hdrAge:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_AGE,result,nil);
end;

// [HTTP_QUERY_ALLOW] : Receives the HTTP verbs supported by the server.
function  TInternetHTTPRequest.get_hdrAllow:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ALLOW,result,nil);
end;

// [HTTP_QUERY_CACHE_CONTROL] : Retrieves the cache control directives.
function  TInternetHTTPRequest.get_hdrCacheControl:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CACHE_CONTROL,result,nil);
end;

// [HTTP_QUERY_CONNECTION]  : Retrieves any options that are specified for a particular connection and must not be communicated by proxies over further connections.
function  TInternetHTTPRequest.get_hdrConnection:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONNECTION,result,nil);
end;

// [HTTP_QUERY_CONTENT_BASE] : Retrieves the base URI (Uniform Resource Identifier) for resolving relative URLs within the entity.
function  TInternetHTTPRequest.get_hdrContentBase:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_BASE,result,nil);
end;

// [HTTP_QUERY_CONTENT_DESCRIPTION] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrContentDesc:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_DESCRIPTION,result,nil);
end;

// [HTTP_QUERY_CONTENT_DISPOSITION] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrContentDisp:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_DISPOSITION,result,nil);
end;

// [HTTP_QUERY_CONTENT_ENCODING] : Retrieves any additional content codings that have been applied to the entire resource.
function  TInternetHTTPRequest.get_hdrContentEncoding:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_ENCODING,result,nil);
end;

// [HTTP_QUERY_CONTENT_ID] : Retrieves the content identification.
function  TInternetHTTPRequest.get_hdrContentID:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_ID,result,nil);
end;

// [HTTP_QUERY_CONTENT_LANGUAGE] : Retrieves the language that the content is in.
function  TInternetHTTPRequest.get_hdrContentLang:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_LANGUAGE,result,nil);
end;

// [HTTP_QUERY_CONTENT_LENGTH] : Retrieves the size of the resource, in bytes.
function  TInternetHTTPRequest.get_hdrContentLength:dword;
begin
  GetResponseIntHeaderProp(HTTP_QUERY_CONTENT_LENGTH,result,nil);
end;

// [HTTP_QUERY_CONTENT_LOCATION] : Retrieves the resource location for the entity enclosed in the message.
function  TInternetHTTPRequest.get_hdrContentLocation:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_LOCATION,result,nil);
end;

// [HTTP_QUERY_CONTENT_MD5] : Retrieves an MD5 digest of the entity-body for the purpose of providing an end-to-end message integrity check (MIC) for the entity-body. For more information, see RFC1864, The Content-MD5 Header Field, at http://ftp.isi.edu/in-notes/rfc1864.txt .
function  TInternetHTTPRequest.get_hdrContentMD5:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_MD5,result,nil);
end;

// [HTTP_QUERY_CONTENT_RANGE] : Retrieves the location in the full entity-body where the partial entity-body should be inserted and the total size of the full entity-body.
function  TInternetHTTPRequest.get_hdrContentRange:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_RANGE,result,nil);
end;

// [HTTP_QUERY_CONTENT_TRANSFER_ENCODING] : Receives the additional content coding that has been applied to the resource.
function  TInternetHTTPRequest.get_hdrContTransEncoding:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_TRANSFER_ENCODING,result,nil);
end;

// [HTTP_QUERY_CONTENT_TYPE] : Receives the content type of the resource (such as text/html).
function  TInternetHTTPRequest.get_hdrContentType:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_CONTENT_TYPE,result,nil);
end;

// [HTTP_QUERY_COOKIE] : Retrieves any cookies associated with the request.
function  TInternetHTTPRequest.get_hdrCookies:TStrings;
var s:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_SET_COOKIE,s,nil);
  fhdrCookies.Text:=s;
  result:=fhdrCookies;
end;

// [HTTP_QUERY_COST] : No longer supported.
function  TInternetHTTPRequest.get_hdrCost:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_COST,result,nil);
end;

// [HTTP_QUERY_DATE]: Receives the date and time at which the message was originated.
function  TInternetHTTPRequest.get_hdrDate:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_DATE,result,nil);
end;

// [HTTP_QUERY_DERIVED_FROM] : No longer supported.
function  TInternetHTTPRequest.get_hdrDerivedFrom:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_DERIVED_FROM,result,nil);
end;

// [HTTP_QUERY_ECHO_HEADERS_CRLF] : Not currently implemented.
function  TInternetHTTPRequest.get_hdrEchoHeaders:TStrings;
var s:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ECHO_HEADERS_CRLF,s,nil);
  fhdrEchoHeaders.Text:=s;
  result:=fhdrEchoHeaders;
end;

// [HTTP_QUERY_ECHO_REPLY] : Not currently implemented.
function  TInternetHTTPRequest.get_hdrEchoReply:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ECHO_REPLY,result,nil);
end;

// [HTTP_QUERY_ECHO_REQUEST] : Not currently implemented.
function  TInternetHTTPRequest.get_hdrEchoRequest:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ECHO_REQUEST,result,nil);
end;

// [HTTP_QUERY_ETAG] : Retrieves the entity tag for the associated entity.
function  TInternetHTTPRequest.get_hdrETag:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ETAG,result,nil);
end;

// [HTTP_QUERY_EXPIRES] : Receives the date and time after which the resource should be considered outdated.
function  TInternetHTTPRequest.get_hdrExpires:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_EXPIRES,result,nil);
end;

// [HTTP_QUERY_FORWARDED] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrForwarded:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_FORWARDED,result,nil);
end;

// [HTTP_QUERY_FROM] : Retrieves the e-mail address for the human user who controls the requesting user agent if the From header is given.
function  TInternetHTTPRequest.get_hdrFrom:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_FROM,result,nil);
end;

// [HTTP_QUERY_HOST] : Retrieves the Internet host and port number of the resource being requested.
function  TInternetHTTPRequest.get_hdrHost:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_HOST,result,nil);
end;

// [HTTP_QUERY_LAST_MODIFIED] : Receives the date and time at which the server believes the resource was last modified.
function  TInternetHTTPRequest.get_hdrLastModified:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_LAST_MODIFIED,result,nil);
end;

// [HTTP_QUERY_LINK] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrLink:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_LINK,result,nil);
end;

// [HTTP_QUERY_LOCATION] : Retrieves the absolute URI (Uniform Resource Identifier) used in a Location response-header.
function  TInternetHTTPRequest.get_hdrLocation:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_LOCATION,result,nil);
end;


// [HTTP_QUERY_MESSAGE_ID] : No longer supported.
function  TInternetHTTPRequest.get_hdrMessageId:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_MESSAGE_ID,result,nil);
end;

// [HTTP_QUERY_MIME_VERSION] : Receives the version of the MIME protocol that was used to construct the message.
function  TInternetHTTPRequest.get_hdrMimeVersion:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_MIME_VERSION,result,nil);
end;

// [HTTP_QUERY_ORIG_URI] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrOrigURI:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_ORIG_URI,result,nil);
end;

// [HTTP_QUERY_PROXY_AUTHENTICATE] : Retrieves the authentication scheme and realm returned by the proxy.
function  TInternetHTTPRequest.get_hdrProxyAuthenticate:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_PROXY_AUTHENTICATE,result,nil);
end;

// [HTTP_QUERY_PUBLIC] : Receives methods available at this server.
function  TInternetHTTPRequest.get_hdrPublic:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_PUBLIC,result,nil);
end;

// [HTTP_QUERY_RAW_HEADERS_CRLF] : Receives all the headers returned by the server. Each header is separated by a carriage return/line feed (CR/LF) sequence.
function  TInternetHTTPRequest.get_hdrRawHeaders:TStrings;
var s:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_RAW_HEADERS_CRLF,s,nil);
  fhdrRawHeaders.Text:=s;
  result:=fhdrRawHeaders;
end;

// [HTTP_QUERY_REFERER] : Receives the URI (Uniform Resource Identifier) of the resource where the requested URI was obtained.
function  TInternetHTTPRequest.get_hdrReferrer:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_REFERER,result,nil);
end;

// [HTTP_QUERY_REFRESH] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrRefresh:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_REFRESH,result,nil);
end;

// [HTTP_QUERY_SERVER] : Retrieves information about the software used by the origin server to handle the request.
function  TInternetHTTPRequest.get_hdrServerDesc:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_SERVER,result,nil);
end;

// [HTTP_QUERY_STATUS_CODE] : Receives the status code returned by the server. For a list of possible values, see HTTP Status Codes.
function  TInternetHTTPRequest.get_hdrStatusCode:dword;
begin
  GetResponseIntHeaderProp(HTTP_QUERY_STATUS_CODE,result,nil);
end;

// [HTTP_QUERY_STATUS_TEXT] : Receives any additional text returned by the server on the response line.
function  TInternetHTTPRequest.get_hdrStatusText:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_STATUS_TEXT,result,nil);
end;

// [HTTP_QUERY_TITLE] : Obsolete. Maintained for legacy application compatibility only.
function  TInternetHTTPRequest.get_hdrTitle:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_TITLE,result,nil);
end;

// [HTTP_QUERY_UPGRADE] : Retrieves the additional communication protocols that are supported by the server.
function  TInternetHTTPRequest.get_hdrUpgrade:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_UPGRADE,result,nil);
end;

// [HTTP_QUERY_URI] : Receives some or all of the Uniform Resource Identifiers (URIs) by which the Request-URI resource can be identified.
function  TInternetHTTPRequest.get_hdrURI:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_URI,result,nil);
end;

// [HTTP_QUERY_VARY] : Retrieves the header that indicates that the entity was selected from a number of available representations of the response using server-driven negotiation.
function  TInternetHTTPRequest.get_hdrVary:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_VARY,result,nil);
end;

// [HTTP_QUERY_VERSION] : Receives the last response code returned by the server.
function  TInternetHTTPRequest.get_hdrVersion:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_VERSION,result,nil);
end;

// [HTTP_QUERY_WARNING] : Retrieves additional information about the status of a response that might not be reflected by the response status code.
function  TInternetHTTPRequest.get_hdrWarning:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_WARNING,result,nil);
end;

// [HTTP_QUERY_WWW_AUTHENTICATE] : Retrieves the authentication scheme and realm returned by the server.
function  TInternetHTTPRequest.get_hdrWWW_Authenticate:string;
begin
  GetResponseHeaderProp(HTTP_QUERY_WWW_AUTHENTICATE,result,nil);
end;
procedure TInternetHTTPRequest.Loaded;
begin
  inherited Loaded;

end;

{*********************************************************************************************************}
{***************************** Beginning of HTTP Cookies Implementation **********************************}
{*********************************************************************************************************}

{ THTTPCookie }

constructor THTTPCookie.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FExpires := -1;
end;

procedure THTTPCookie.AssignTo(Dest: TPersistent);
begin
  if Dest is THTTPCookie then
    with THTTPCookie(Dest) do
    begin
      Name := Self.FName;
      Value := Self.FValue;
      Path := Self.FPath;
      Expires := Self.FExpires;
      Secure := Self.FSecure;
    end else inherited AssignTo(Dest);
end;

function THTTPCookie.GetHeaderValue: string;
var aName:string;
begin
  {Result := Format('%s=%s; ', [HTTPEncode(FName), HTTPEncode(FValue)]);
  if Domain <> '' then
    Result := Result + Format('domain=%s; ', [Domain]);
  if Path <> '' then
    Result := Result + Format('path=%s; ', [Path]);
  if Expires > -1 then
    Result := Result +
      Format(FormatDateTime('"expires="' + sDateFormat + ' "GMT; "', Expires),
        [DayOfWeekStr(Expires), MonthStr(Expires)]);
  if Secure then Result := Result + 'secure';
  if Copy(Result, Length(Result) - 1, MaxInt) = '; ' then
    SetLength(Result, Length(Result) - 2);
  }
  if CompareText(fNAme,'NO_NAME')=0 then
    aNAme:=''
  else
    aName:=fNAme;
  result:=Format('%s=%s; ', [HTTPEncode(aName), HTTPEncode(FValue)]);
end;
function THTTPCookie.GetDomain:string;
begin
  result:=THTTPCookies(Collection).Domain;
end;
procedure THTTPCookie.SetName(aName:string);
begin
  if aName='' then
    fNAme:='NO_NAME'
  else
    fName:=aName;
end;
function  THTTPCookie.get_isSessionCookie:boolean;
begin
  result:=Expires=-1;
end;
{ THTTPCookies }

constructor THTTPCookies.Create(aOwner:TCustomInternetConnection);
begin
  inherited Create(THTTPCookie);
  fOwner:=aOwner;
end;
destructor THTTPCookies.destroy;
begin
  SaveToDisk;
  inherited destroy;
end;
function THTTPCookies.FindCookie(CookieName:string):THTTPCookie;
var i:integer;
begin
  result:=nil;
  if CookieName='' then
    CookieName:='NO_NAME';
  for i:=0 to Count-1 do
  begin
    if CompareText(itemByIndex[i].Name,CookieName)=0 then
    begin
      result:=itemByIndex[i];
      break;
    end;
  end;
end;
procedure THTTPCookies.ExtractCookieFields(CookieStr:string;Strings: TStrings);
begin
  ExtractHeaderFields([';'], [' '], PChar(CookieStr), Strings, True);
end;

Const

  Months: array[1..12] of string = (
    'Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug',
    'Sep', 'Oct', 'Nov', 'Dec');
  DaysOfWeek: array[1..7] of string = (
    'Sun', 'Mon', 'Tue', 'Wed',
    'Thu', 'Fri', 'Sat');

function ParseCookieDate_(DateStr: string): TDateTime;
var
  Month, Day, Year, Hour, Minute, Sec,msec: word;
  DayOfWeek:integer;
  Parser: TParser;
  StringStream: TStringStream;
  t:integer;
  DatePart,TimePart,s:string;

  function GetMonth: Boolean;
  begin
    if Month < 13 then
    begin
      Result := False;
      Exit;
    end;
    Month := 1;
    while not Parser.TokenSymbolIs(Months[Month]) and (Month < 13) do Inc(Month);
    Result := Month < 13;
  end;

  function GetDayOfWeek: Boolean;
  begin
    if DayOfWeek < 8 then
    begin
      Result := False;
      Exit;
    end;
    DayOfWeek := 1;
    while not Parser.TokenSymbolIs(DaysOfWeek[DayOfWeek]) and (DayOfWeek < 8) do Inc(DayOfWeek);
    Result := DayOfWeek < 13;
  end;

  procedure GetTime;
  begin
    with Parser do
    begin
      Hour := TokenInt;
      NextToken;
      if Token = ':' then NextToken;
      Minute := TokenInt;
      NextToken;
      if Token = ':' then NextToken;
      Sec := TokenInt;
      NextToken;
    end;
  end;

begin
  Month := 13;
  DayOfWeek  :=8;
  Day:=1;
  if pos('-',datestr)>0 then
  begin
    DateStr:=StringReplace(DateStr,' ',';',[rfReplaceAll, rfIgnoreCase]);
    StringStream := TStringStream.Create(DateStr);
    Parser := TParser.Create(StringStream);
    try
      if GetDayOfWeek then
        Parser.NextToken;
      if Parser.Token = ',' then
        Parser.NextToken;
      if Parser.Token = ';' then
        Parser.NextToken;
      s:='';
      While Parser.Token <> ';' do
      begin
        s:=s+Parser.TokenString;
        Parser.NextToken;
      end;
      DatePart:=s;
      if Parser.Token = ';' then
        Parser.NextToken;
      s:='';
      While Parser.Token <> ';' do
      begin
        s:=s+Parser.TokenString;
        Parser.NextToken;
      end;
      TimePart:=s;
    finally
      Parser.Free;
      StringStream.free;
    end;
    DateStr:=DatePart;
    DateStr:=StringReplace(DateStr,'-','/',[rfReplaceAll, rfIgnoreCase]);
    StringStream := TStringStream.Create(DateStr);
    Parser := TParser.Create(StringStream);
    try
      if TryStrToInt(Parser.TokenString,t) then
      begin
        Day := Parser.TokenInt;
        if Parser.NextToken='/' then
          Parser.NextToken;
        if Parser.Token = ':' then Parser.NextToken;
        if Parser.Token = ',' then Parser.NextToken;
      end;
      if GetMonth then
      begin
        if Parser.NextToken='/' then
          Parser.NextToken;
        Year := Parser.TokenInt;
      end else
      begin
        Day := Parser.TokenInt;
        Parser.NextToken;
        if Parser.Token = '-' then Parser.NextToken;
        GetMonth;
        Parser.NextToken;
        if Parser.Token = '-' then Parser.NextToken;
        Year := Parser.TokenInt;
        if Year < 100 then Inc(Year, 1900);
        Parser.NextToken;
      end;
    finally
      Parser.Free;
      StringStream.free;
    end;
    result:=StrToTime(TimePart);
    DecodeTime(result,Hour,Minute,Sec,msec);
  end
  else
  begin
    StringStream := TStringStream.Create(DateStr);
    Parser := TParser.Create(StringStream);
    try
      if GetDayOfWeek then
        if Parser.NextToken=',' then
          Parser.NextToken;
      with Parser do
      begin
        Day := TokenInt;
        NextToken;
        if Token = ':' then NextToken;
        if Token = ',' then NextToken;
        if GetMonth then
        begin
          NextToken;
          Year := TokenInt;
          NextToken;
          GetTime;
        end else
        begin
          Day := TokenInt;
          NextToken;
          if Token = '-' then NextToken;
          GetMonth;
          NextToken;
          if Token = '-' then NextToken;
          Year := TokenInt;
          if Year < 100 then Inc(Year, 1900);
          NextToken;
          GetTime;
        end;
      end;
    finally
      Parser.Free;
      StringStream.free;
    end;
  end;
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Sec, 0);
end;
Procedure THTTPCookies.PlaceCookie(CookieHeader:string);
var
  sList:TStringList;
  item:THTTPCookie;
  pst:TSystemTime;
begin
  {Result := Format('%s=%s; ', [HTTPEncode(FName), HTTPEncode(FValue)]);
  if Domain <> '' then
    Result := Result + Format('domain=%s; ', [Domain]);
  if Path <> '' then
    Result := Result + Format('path=%s; ', [Path]);
  if Expires > -1 then
    Result := Result +
      Format(FormatDateTime('"expires="' + sDateFormat + ' "GMT; "', Expires),
        [DayOfWeekStr(Expires), MonthStr(Expires)]);
  if Secure then Result := Result + 'secure';
  if Copy(Result, Length(Result) - 1, MaxInt) = '; ' then
    SetLength(Result, Length(Result) - 2);
  }
  sList:=TStringList.Create;
  try
    ExtractCookieFields(CookieHeader,sList);
    if assigned(FindCookie(sList.Names[0])) then
      item:=FindCookie(sList.Names[0])
    else
      item:=Add;
    item.Name:=sList.Names[0];
    item.Value:=sList.Values[sList.Names[0]];
    item.Path:=sList.Values['path'];
    try
      if sList.Values['expires']<>'' then
      begin
        if not InternetTimeToSystemTime(pchar(sList.Values['expires']),pst,0) then
          RaiseLastAPIError;
        item.Expires:=SystemTimeToDateTime(pst);
      end
      else
        item.Expires:=-1;
    except on e:exception do
      item.Expires:=-1;
    end;
    item.Secure:=Pos(';secure',sList.Text)>0;
    SaveToDisk;
  finally
    sList.Free;
  end;
end;
Function THTTPCookies.GetCookieHeader:string;
var i:integer;
begin
  for i:=0 to Count-1 do
      result:=result+itemByIndex[i].GetHeaderValue;
  if Copy(Result, Length(Result) - 1, MaxInt) = '; ' then
    SetLength(Result, Length(Result) - 2);

end;

procedure THTTPCookies.LoadFromDisk;
var
  ini:TIniFile;
  sList:TStringList;
  i:integer;
  item:THTTPCookie;
begin
  if domain='' then exit;
  clear;
  ini:=TIniFile.Create(GetFileName);
  try
    sList:=TStringList.Create;
    try
      ini.ReadSections(sList);
      for i:=0 to sList.Count-1 do
      if ini.ReadDateTime(sList[i],'EXPIRES',-1)<>-1 then
      begin
        if assigned(FindCookie(sList[i])) then
          item:=FindCookie(sList[i])
        else
          item:=Add;
        item.Name   :=sList[i];
        item.Value  :=ini.ReadString  (sList[i],'VALUE'  ,'');
        item.Path   :=ini.ReadString  (sList[i],'PATH'   ,'/');
        item.Expires:=ini.ReadDateTime(sList[i],'EXPIRES',-1);
        item.Secure :=ini.ReadBool    (slist[i],'SECURE' ,false);
      end;
    finally
      sList.Free;
    end;
  finally
    ini.Free;
  end;
end;
procedure THTTPCookies.SaveToDisk;
var
  ini:TIniFile;
  i:integer;
begin
  if domain='' then exit;
  ini:=TIniFile.Create(GetFileName);
  try
    for i:=0 to Count-1 do
    if itemByIndex[i].Expires<>-1 then
    begin
      ini.WriteString(itemByIndex[i].Name,'VALUE',itemByIndex[i].Value);
      ini.WriteString(itemByIndex[i].Name,'PATH',itemByIndex[i].Path);
      ini.WriteDateTime(itemByIndex[i].name,'EXPIRES',itemByIndex[i].Expires);
      ini.WriteBool(itemByIndex[i].Name,'SECURE',itemByIndex[i].Secure);
    end;
  finally
    ini.Free;
  end;
end;
function THTTPCookies.GetFileName:string;
var
  s:string;
  path:string;
begin
  if Domain='' then
    raise Exception.Create('Domain property is null.Cannot produce file name');
  s:=domain;
  s:=StringReplace(s,'http://','', [rfReplaceAll, rfIgnoreCase]);
  s:=StringReplace(s,'.','_', [rfReplaceAll, rfIgnoreCase]);
  s:=s+'.cookie';
  path:=GetCookieFilesBasePath+'cookies';
  if not DirectoryExists(path) then
    CreateDir(path);
  if path[length(path)]<>'\' then
    path:=path+'\';
  path:=path+getCurrUser;
  if not DirectoryExists(path) then
    CreateDir(path);
  if path[length(path)]<>'\' then
    path:=path+'\';
  result:=path+s;
end;
function  THTTPCookies.GetCookieFilesBasePath:string;
var
  mName:string;
begin
  if fBasePath<>'' then
    result:=fBasePath
  else
  begin
    mName:=GetModuleName(hInstance);
    result:=ExtractFilePath(mName);
  end;
end;
function  THTTPCookies.getCurrUser:string;
begin
  if assigned(fOwner) then
    if assigned(fOwner.Session) then
      result:=fOwner.Session.CurrentUser;
end;

function  THTTPCookies.getDomain:string;
begin
  if assigned(fOwner) then
    result:=fOwner.Server;
end;

procedure THTTPCookies.SetDomain(aDomain:string);//write buffer to disk;read new values
begin
  if fDomain<>'' then
    SaveToDisk;
  if (aDomain<>'') and (CompareText(fDomain,aDomain)<>0) then
  begin
    fDomain:=aDomain;
    LoadFromDisk;
  end;

end;

function THTTPCookies.Add: THTTPCookie;
begin
  Result := THTTPCookie(inherited Add);
end;

function THTTPCookies.GetCookie(Index: Integer): THTTPCookie;
begin
  Result := THTTPCookie(inherited Items[Index]);
end;

procedure THTTPCookies.SetCookie(Index: Integer; Cookie: THTTPCookie);
begin
  Items[Index].Assign(Cookie);
end;
function  THTTPCookies.GetCookieByName(Index:string): THTTPCookie;
var i:integer;
begin
  result:=nil;
  for i:=0 to count-1 do
  begin
    if compareText(ItemByIndex[i].Name,Index)=0 then
    begin
      result:=ItemByIndex[i];
      break;
    end;
  end;
  if not assigned(result) then
    Raise Exception.Create(format(sExceptionCookieNotFound,[index]));
end;
procedure THTTPCookies.SetCookieByName(Index:string; p:THTTPCookie);
var
  i:integer;
  itemToUpdate:THTTPCookie;
begin
  itemToUpdate:=nil;
  for i:=0 to count-1 do
  begin
    if compareText(ItemByIndex[i].Name,Index)=0 then
    begin
      itemToUpdate:=ItemByIndex[i];
      break;
    end;
  end;
  if not assigned(itemToUpdate) then
    Raise Exception.Create(format(sExceptionCookieNotFound,[index]));
end;


{*********************************************************************************************************}
{***************************** End of HTTP Cookies Implementation ****************************************}
{*********************************************************************************************************}


initialization
//  if not assigned(Callbacks) then
//    Callbacks := TObjectList.Create(True); // Will own objects so it destroys the list items automatically
//  if not assigned(iSession) then
//    iSession:= TInternetSession.Create(nil);
finalization
{  if assigned(iSession) then
  begin
    try
      if iSession.Active then
        iSession.close;
    finally
      iSession.Free;
      iSession:=nil;
    end;
  end;
  try
    if Assigned(Callbacks) then
      Callbacks.Free;
  finally
    Callbacks:=nil;
  end;
}
end.
