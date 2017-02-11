{*************************************************************
www:          http://sourceforge.net/projects/alcinoe/              
Author(s):    Sergey Seroukhov (Zeos Database Objects)
              based on Mysql-direct library by Cristian Nicola
Sponsor(s):   Arkadia SA (http://www.arkadia.com)
							Delphinaute.com (http://www.delphinaute.com)
							
product:      ALMySqlWrapper
Version:      3.50

Description:  MysQL libmysql.dll Version 5 API Interface Unit

Legal issues: Copyright (C) 2005 by St�phane Vander Clock

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :

Link :        http://www.sourceforge.net/projects/zeoslib
              http://dev.mysql.com/doc/refman/5.0/en/c-api-functions.html

Please send all your feedback to svanderclock@delphinaute.com
**************************************************************}
unit ALMySqlWrapper;

interface

const

{ General Declarations }
  MYSQL_ERRMSG_SIZE    = 512;
  SQLSTATE_LENGTH      = 5;
  SCRAMBLE_LENGTH      = 20;

  MYSQL_PORT           = 3306;
  LOCAL_HOST           = 'localhost';
  NAME_LEN             = 64;
  PROTOCOL_VERSION     = 10;
  FRM_VER              = 6;

{ Field's flags }
  NOT_NULL_FLAG          = 1;     { Field can't be NULL }
  PRI_KEY_FLAG           = 2;     { Field is part of a primary key }
  UNIQUE_KEY_FLAG        = 4;     { Field is part of a unique key }
  MULTIPLE_KEY_FLAG      = 8;     { Field is part of a key }
  BLOB_FLAG              = 16;    { Field is a blob }
  UNSIGNED_FLAG          = 32;    { Field is unsigned }
  ZEROFILL_FLAG          = 64;    { Field is zerofill }
  BINARY_FLAG            = 128;   { Field is binary }
  ENUM_FLAG              = 256;   { Field is an enum }
  AUTO_INCREMENT_FLAG    = 512;   { Field is a autoincrement field }
  TIMESTAMP_FLAG         = 1024;  { Field is a timestamp }
  SET_FLAG               = 2048;  { Field is a set }
  NUM_FLAG               = 32768; { Field is num (for clients) }
  PART_KEY_FLAG	         = 16384; { Intern; Part of some key }
  GROUP_FLAG	         = 32768; { Intern: Group field }
  UNIQUE_FLAG            = 65536; { Intern: Used by sql_yacc }
  BINCMP_FLAG            = $20000; { Intern: Used by sql_yacc }

{ Server Administration Refresh Options }
  REFRESH_GRANT	           = 1;     { Refresh grant tables }
  REFRESH_LOG		       = 2;     { Start on new log file }
  REFRESH_TABLES	       = 4;     { close all tables }
  REFRESH_HOSTS	           = 8;     { Flush host cache }
  REFRESH_STATUS           = 16;    { Flush status variables }
  REFRESH_THREADS          = 32;    { Flush status variables }
  REFRESH_SLAVE            = 64;    { Reset master info abd restat slave thread }
  REFRESH_MASTER           = 128;   { Remove all bin logs in the index and truncate the index }
  REFRESH_READ_LOCK        = 16384; { Lock tables for read }
  REFRESH_FAST		       = 32768; { Intern flag }
  REFRESH_QUERY_CACHE	   = 65536;
  REFRESH_QUERY_CACHE_FREE = $20000; { Pack query cache }
  REFRESH_DES_KEY_FILE	   = $40000;
  REFRESH_USER_RESOURCES   = $80000;

{ Client Connection Options }
  _CLIENT_LONG_PASSWORD	    = 1;	 { new more secure passwords }
  _CLIENT_FOUND_ROWS	    = 2;	 { Found instead of affected rows }
  _CLIENT_LONG_FLAG	        = 4;	 { Get all column flags }
  _CLIENT_CONNECT_WITH_DB   = 8;	 { One can specify db on connect }
  _CLIENT_NO_SCHEMA	        = 16;	 { Don't allow database.table.column }
  _CLIENT_COMPRESS	        = 32;	 { Can use compression protcol }
  _CLIENT_ODBC		        = 64;    { Odbc client }
  _CLIENT_LOCAL_FILES	    = 128;   { Can use LOAD DATA LOCAL }
  _CLIENT_IGNORE_SPACE	    = 256;   { Ignore spaces before '(' }
  _CLIENT_PROTOCOL_41	    = 512;   { New 4.1 protocol }
  _CLIENT_INTERACTIVE	    = 1024;  { This is an interactive client }
  _CLIENT_SSL               = 2048;  { Switch to SSL after handshake }
  _CLIENT_IGNORE_SIGPIPE    = $1000;    { IGNORE sigpipes }
  _CLIENT_TRANSACTIONS	    = $2000;    { Client knows about transactions }
  _CLIENT_RESERVED          = $4000;    { Old flag for 4.1 protocol  }
  _CLIENT_SECURE_CONNECTION = $8000;    { New 4.1 authentication }
  _CLIENT_MULTI_STATEMENTS  = $10000;   { Enable/disable multi-stmt support }
  _CLIENT_MULTI_RESULTS     = $20000;   { Enable/disable multi-results }
  _CLIENT_REMEMBER_OPTIONS  = $8000000; {Enable/disable multi-results }

  SERVER_STATUS_IN_TRANS          = 1;   {Transaction has started}
  SERVER_STATUS_AUTOCOMMIT        = 2;   {Server in Autocommit Mode}
  SERVER_STATUS_MORE_RESULTS      = 4;   {More results on server}
  SERVER_MORE_RESULTS_EXISTS      = 8;   {Multiple query, next query exists}
  SERVER_QUERY_NO_GOOD_INDEX_USED = 16;
  SERVER_QUERY_NO_INDEX_USED      = 32;
  SERVER_STATUS_DB_DROPPED        = 256; {A database was dropped}

  NET_READ_TIMEOUT          = 30;        {timeout on read}
  NET_WRITE_TIMEOUT         = 60;        {timeout on write}
  NET_WAIT_TIMEOUT          = 28800;     {wait for new query}

{ Net type }
  NET_TYPE_TCPIP     = 0;
  NET_TYPE_SOCKET    = 1;
  NET_TYPE_NAMEDPIPE = 2;

{THD: Killable}
  MYSQL_SHUTDOWN_KILLABLE_CONNECT    = 1;
  MYSQL_SHUTDOWN_KILLABLE_TRANS      = 2;
  MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE = 4;
  MYSQL_SHUTDOWN_KILLABLE_UPDATE     = 8;

{prepared fetch results}
  STMT_FETCH_OK         = 0;
  STMT_FETCH_ERROR      = 1;
  STMT_FETCH_NO_DATA    = 100;
  STMT_FETCH_DATA_TRUNC = 101;

type
    PZMySQLConnect = Pointer;
    PZMySQLResult = Pointer;
    PZMySQLRow = Pointer;
    PZMySQLField = Pointer;
    PZMySQLRowOffset = Pointer;
    PZMySqlPrepStmt = Pointer;
    PZMysqlBindArray = Pointer;

{ Enum Field Types }
    TMysqlFieldTypes = (
        MYSQL_TYPE_DECIMAL,
        MYSQL_TYPE_TINY,         {BIND}
        MYSQL_TYPE_SHORT,        {BIND}
        MYSQL_TYPE_LONG,         {BIND}
        MYSQL_TYPE_FLOAT,        {BIND}
        MYSQL_TYPE_DOUBLE,       {BIND}
        MYSQL_TYPE_NULL,
        MYSQL_TYPE_TIMESTAMP,    {BIND}
        MYSQL_TYPE_LONGLONG,     {BIND}
        MYSQL_TYPE_INT24,
        MYSQL_TYPE_DATE,         {BIND}
        MYSQL_TYPE_TIME,         {BIND}
        MYSQL_TYPE_DATETIME,     {BIND}
        MYSQL_TYPE_YEAR,
        MYSQL_TYPE_NEWDATE,
        MYSQL_TYPE_VARCHAR, //<--ADDED by fduenas 20-06-2006
        MYSQL_TYPE_BIT,     //<--ADDED by fduenas 20-06-2006
        MYSQL_TYPE_NEWDECIMAL, 
        MYSQL_TYPE_ENUM,
        MYSQL_TYPE_SET,
        MYSQL_TYPE_TINY_BLOB,    {BIND}
        MYSQL_TYPE_MEDIUM_BLOB,  {BIND}
        MYSQL_TYPE_LONG_BLOB,    {BIND}
        MYSQL_TYPE_BLOB,         {BIND}
        MYSQL_TYPE_VAR_STRING,   {BIND}
        MYSQL_TYPE_STRING,       {BIND}
        MYSQL_TYPE_GEOMETRY
    );

  TMysqlStmtAttrType = (
    STMT_ATTR_UPDATE_MAX_LENGTH,
    STMT_ATTR_CURSOR_TYPE,
    STMT_ATTR_PREFETCH_ROWS
  );

  TMysqlShutdownLevel = (
    SHUTDOWN_DEFAULT = 0,
    SHUTDOWN_WAIT_CONNECTIONS = MYSQL_SHUTDOWN_KILLABLE_CONNECT,
    SHUTDOWN_WAIT_TRANSACTIONS = MYSQL_SHUTDOWN_KILLABLE_TRANS,
    SHUTDOWN_WAIT_UPDATES = MYSQL_SHUTDOWN_KILLABLE_UPDATE,
    SHUTDOWN_WAIT_ALL_BUFFERS = (MYSQL_SHUTDOWN_KILLABLE_UPDATE shl 1),
    SHUTDOWN_WAIT_CRITICAL_BUFFERS,
    KILL_QUERY = 254,
    KILL_CONNECTION = 255
  );

  TMySqlProtocolType = (
    MYSQL_PROTOCOL_DEFAULT,
    MYSQL_PROTOCOL_TCP,
    MYSQL_PROTOCOL_SOCKET,
    MYSQL_PROTOCOL_PIPE,
    MYSQL_PROTOCOL_MEMORY
  );

  TMysqlStmtState = (
    MYSQL_STMT_INIT_DONE = 1,
    MYSQL_STMT_PREPARE_DONE,
    MYSQL_STMT_EXECUTE_DONE,
    MYSQL_STMT_FETCH_DONE
  );

  MYSQL_TIME = record
    year:                Cardinal;
    month:               Cardinal;
    day:                 Cardinal;
    hour:                Cardinal;
    minute:              Cardinal;
    second:              Cardinal;
    neg:                 Byte;
    second_part:         Int64;
  end;

  PLIST = ^LIST;
  LIST = record
    prev:       PLIST;
    next:       PLIST;
    data:       Pointer;
  end;

  PMYSQL_BIND2 = ^MYSQL_BIND2;
  MYSQL_BIND2 =  record
    length:            PLongInt;
    is_null:           PByte;
    buffer:            PChar;
    error:             PByte;
    buffer_type:       Byte;
    buffer_length:     LongInt;
    row_ptr:           PByte;
    offset:            LongInt;
    length_value:      LongInt;
    param_number:      Cardinal;
    pack_length:       Cardinal;
    error_value:       Byte;
    is_unsigned:       Byte;
    long_data_used:    Byte;
    is_null_value:     Byte;
    store_param_funct: Pointer;
    fetch_result:      Pointer;
    skip_result:       Pointer;
  end;

  PDOBindRecord2 = record
      buffer:    Array of Byte;
      length:    LongWord;
      is_null:   Byte;
  end;

const
  EMBEDDED_DEFAULT_DATA_DIR = '.\data\';
  SERVER_ARGUMENTS_KEY_PREFIX = 'ServerArgument';
  SERVER_GROUPS : array [0..2] of PChar = ('embedded'#0, 'server'#0, nil);
  DEFAULT_PARAMS : array [0..2] of PChar = ('not_used'#0,
                                            '--datadir='+EMBEDDED_DEFAULT_DATA_DIR+#0,
                                            '--set-variable=key_buffer_size=32M'#0);

const
{ General Declarations }
//  PROTOCOL_VERSION     = 10;
//  FRM_VER              = 6;

{ Enum Field Types }
  FIELD_TYPE_DECIMAL   = 0;
  FIELD_TYPE_TINY      = 1;
  FIELD_TYPE_SHORT     = 2;
  FIELD_TYPE_LONG      = 3;
  FIELD_TYPE_FLOAT     = 4;
  FIELD_TYPE_DOUBLE    = 5;
  FIELD_TYPE_NULL      = 6;
  FIELD_TYPE_TIMESTAMP = 7;
  FIELD_TYPE_LONGLONG  = 8;
  FIELD_TYPE_INT24     = 9;
  FIELD_TYPE_DATE      = 10;
  FIELD_TYPE_TIME      = 11;
  FIELD_TYPE_DATETIME  = 12;
  FIELD_TYPE_YEAR      = 13;
  FIELD_TYPE_NEWDATE   = 14;
  FIELD_TYPE_VARCHAR   = 15; //<--ADDED by fduenas 20-06-2006
  FIELD_TYPE_BIT       = 16; //<--ADDED by fduenas 20-06-2006
  FIELD_TYPE_NEWDECIMAL = 246; //<--ADDED by fduenas 20-06-2006
  FIELD_TYPE_ENUM      = 247;
  FIELD_TYPE_SET       = 248;
  FIELD_TYPE_TINY_BLOB = 249;
  FIELD_TYPE_MEDIUM_BLOB = 250;
  FIELD_TYPE_LONG_BLOB = 251;
  FIELD_TYPE_BLOB      = 252;
  FIELD_TYPE_VAR_STRING = 253;
  FIELD_TYPE_STRING    = 254;
  FIELD_TYPE_GEOMETRY  = 255;

{ For Compatibility }
  FIELD_TYPE_CHAR      = FIELD_TYPE_TINY;
  FIELD_TYPE_INTERVAL  = FIELD_TYPE_ENUM;

  MAX_MYSQL_MANAGER_ERR = 256;
  MAX_MYSQL_MANAGER_MSG = 256;

  MANAGER_OK           = 200;
  MANAGER_INFO         = 250;
  MANAGER_ACCESS       = 401;
  MANAGER_CLIENT_ERR   = 450;
  MANAGER_INTERNAL_ERR = 500;

type
  TClientCapabilities = (
    CLIENT_LONG_PASSWORD,
    CLIENT_FOUND_ROWS,
    CLIENT_LONG_FLAG,
    CLIENT_CONNECT_WITH_DB,
    CLIENT_NO_SCHEMA,
    CLIENT_COMPRESS,
    CLIENT_ODBC,
    CLIENT_LOCAL_FILES,
    CLIENT_IGNORE_SPACE
  );

  TSetClientCapabilities = set of TClientCapabilities;

  TRefreshOptions = (
    _REFRESH_GRANT,
    _REFRESH_LOG,
    _REFRESH_TABLES,
    _REFRESH_HOSTS,
    _REFRESH_FAST
  );
  TSetRefreshOptions = set of TRefreshOptions;

  TMySqlStatus = (
    MYSQL_STATUS_READY,
    MYSQL_STATUS_GET_RESULT,
    MYSQL_STATUS_USE_RESULT
  );

  TMySqlOption = (
    MYSQL_OPT_CONNECT_TIMEOUT,
    MYSQL_OPT_COMPRESS,
    MYSQL_OPT_NAMED_PIPE,
    MYSQL_INIT_COMMAND,
    MYSQL_READ_DEFAULT_FILE,
    MYSQL_READ_DEFAULT_GROUP,
    MYSQL_SET_CHARSET_DIR,
    MYSQL_SET_CHARSET_NAME,
    MYSQL_OPT_LOCAL_INFILE,
    MYSQL_OPT_PROTOCOL,
    MYSQL_SHARED_MEMORY_BASE_NAME,
    MYSQL_OPT_READ_TIMEOUT,
    MYSQL_OPT_WRITE_TIMEOUT,
    MYSQL_OPT_USE_RESULT,
    MYSQL_OPT_USE_REMOTE_CONNECTION,
    MYSQL_OPT_USE_EMBEDDED_CONNECTION,
    MYSQL_OPT_GUESS_CONNECTION,
    MYSQL_SET_CLIENT_IP,
    MYSQL_SECURE_AUTH
  );

  TMySqlRplType = (
    MYSQL_RPL_MASTER,
    MYSQL_RPL_SLAVE,
    MYSQL_RPL_ADMIN
  );

  TMySqlServerCommand = (
    COM_SLEEP,
    COM_QUIT,
    COM_INIT_DB,
    COM_QUERY,
    COM_FIELD_LIST,
    COM_CREATE_DB,
    COM_DROP_DB,
    COM_REFRESH,
    COM_SHUTDOWN,
    COM_STATISTICS,
    COM_PROCESS_INFO,
    COM_CONNECT,
    COM_PROCESS_KILL,
    COM_DEBUG,
    COM_PING,
    COM_TIME,
    COM_DELAYED_INSERT,
    COM_CHANGE_USER,
    COM_BINLOG_DUMP,
    COM_TABLE_DUMP,
    COM_CONNECT_OUT,
    COM_REGISTER_SLAVE,
    COM_PREPARE,
    COM_EXECUTE,
    COM_LONG_DATA,
    COM_CLOSE_STMT,
    COM_RESET_STMT,
    COM_SET_OPTION,
    COM_END
  );

  PUSED_MEM=^USED_MEM;
  USED_MEM = packed record
    next:       PUSED_MEM;
    left:       Integer;
    size:       Integer;
  end;

  PERR_PROC = ^ERR_PROC;
  ERR_PROC = procedure;

  PMEM_ROOT = ^MEM_ROOT;
  MEM_ROOT = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
    pre_alloc:     PUSED_MEM;
    min_malloc:    Integer;
    block_size:    Integer;
    block_num:     Integer;
    first_block_usage: Integer;
    error_handler: PERR_PROC;
  end;

  NET = record
    vio:              Pointer;
    buff:             PChar;
    buff_end:         PChar;
    write_pos:        PChar;
    read_pos:         PChar;
    fd:               Integer;
    max_packet:       Cardinal;
    max_packet_size:  Cardinal;
    pkt_nr:           Cardinal;
    compress_pkt_nr:  Cardinal;
    write_timeout:    Cardinal;
    read_timeout:     Cardinal;
    retry_count:      Cardinal;
    fcntl:            Integer;
    compress:         Byte;
    remain_in_buf:    LongInt;
    length:           LongInt;
    buf_length:       LongInt;
    where_b:          LongInt;
    return_status:    Pointer;
    reading_or_writing: Char;
    save_char:        Char;
    no_send_ok:       Byte;
    last_error:       array[1..MYSQL_ERRMSG_SIZE] of Char;
    sqlstate:         array[1..SQLSTATE_LENGTH + 1] of Char;
    last_errno:       Cardinal;
    error:            Char;
    query_cache_query: Pointer;
    report_error:     Byte;
    return_errno:     Byte;
  end;

  PMYSQL_FIELD = ^MYSQL_FIELD;
  MYSQL_FIELD = record
    name:             PChar;   // Name of column
    org_name:         PChar;   // Original column name, if an alias
    table:            PChar;   // Table of column if column was a field
    org_table:        PChar;   // Org table name if table was an alias
    db:               PChar;   // Database for table
    catalog:	      PChar;   // Catalog for table
    def:              PChar;   // Default value (set by mysql_list_fields)
    length:           LongInt; // Width of column
    max_length:       LongInt; // Max width of selected set
    name_length:      Cardinal;
    org_name_length:  Cardinal;
    table_length:     Cardinal;
    org_table_length: Cardinal;
    db_length:        Cardinal;
    catalog_length:   Cardinal;
    def_length:       Cardinal;
    flags:            Cardinal; // Div flags
    decimals:         Cardinal; // Number of decimals in field
    charsetnr:        Cardinal; // Character set
    _type:            Cardinal; // Type of field. Se mysql_com.h for types
  end;

  MYSQL_FIELD_OFFSET = Cardinal;

  MYSQL_ROW = array[00..$ff] of PChar;
  PMYSQL_ROW = ^MYSQL_ROW;

  PMYSQL_ROWS = ^MYSQL_ROWS;
  MYSQL_ROWS = record
    next:       PMYSQL_ROWS;
    data:       PMYSQL_ROW;
  end;

  MYSQL_ROW_OFFSET = PMYSQL_ROWS;

  MYSQL_DATA = record
    Rows:       Int64;
    Fields:     Cardinal;
    Data:       PMYSQL_ROWS;
    Alloc:      MEM_ROOT;
  end;
  PMYSQL_DATA = ^MYSQL_DATA;

  PMYSQL_OPTIONS = ^_MYSQL_OPTIONS;
  _MYSQL_OPTIONS = record
    connect_timeout:          Cardinal;
    read_timeout:             Cardinal;
    write_timeout:            Cardinal;
    port:                     Cardinal;
    protocol:                 Cardinal;
    client_flag:              LongInt;
    host:                     PChar;
    user:                     PChar;
    password:                 PChar;
    unix_socket:              PChar;
    db:                       PChar;
    init_commands:            Pointer;
    my_cnf_file:              PChar;
    my_cnf_group:             PChar;
    charset_dir:              PChar;
    charset_name:             PChar;
    ssl_key:                  PChar;
    ssl_cert:                 PChar;
    ssl_ca:                   PChar;
    ssl_capath:               PChar;
    ssl_cipher:               PChar;
    shared_memory_base_name:  PChar;
    max_allowed_packet:       LongInt;
    use_ssl:                  Byte;
    compress:                 Byte;
    named_pipe:               Byte;
    rpl_probe:                Byte;
    rpl_parse:                Byte;
    no_master_reads:          Byte;
    separate_thread:          Byte;
    methods_to_use:           TMySqlOption;
    client_ip:                PChar;
    secure_auth:              Byte;
    local_infile_init:        Pointer;
    local_infile_read:        Pointer;
    local_infile_end:         Pointer;
    local_infile_error:       Pointer;
    local_infile_userdata:    Pointer;
  end;

  PMY_CHARSET_INFO = ^MY_CHARSET_INFO;
  MY_CHARSET_INFO = record
    number:         Cardinal;
    state:          Cardinal;
    csname:         PChar;
    name:           PChar;
    comment:        PChar;
    dir:            PChar;
    mbminlen:       Cardinal;
    mbmaxlen:       Cardinal;
  end;

  PMYSQL_METHODS =  ^MYSQL_METHODS;
  PMYSQL = ^MYSQL;

  MYSQL  = pointer;

  MYSQL_RES = record
    row_count:       Int64;
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    lengths:         PLongInt;
    handle:          PMYSQL;
    field_alloc:     MEM_ROOT;
    field_count:     Integer;
    current_field:   Integer;
    row:             PMYSQL_ROW;
    current_row:     PMYSQL_ROW;
    eof:             Byte;
    unbuffered_fetch_cancelled: Byte;
    methods:         PMYSQL_METHODS;
  end;
  PMYSQL_RES = ^MYSQL_RES;

  PREP_STMT_STATE=(
    MY_ST_UNKNOWN,
    MY_ST_PREPARE,
    MY_ST_EXECUTE);

  PMYSQL_BIND = ^MYSQL_BIND;
  MYSQL_BIND = record
    length:           PLongInt;
    is_null:          PByte;
    buffer:           PChar;
    buffer_type:      Cardinal;
    buffer_length:    LongInt;
    inter_buffer:     PByte;
    offset:           LongInt;
    internal_length:  LongInt;
    param_number:     Cardinal;
    long_data_used:   Byte;
    binary_data:      Byte;
    null_field:       Byte;
    internal_is_null: Byte;
    store_param_func: procedure(_net: NET; param: PMYSQL_BIND);
    fetch_result:     procedure(param: PMYSQL_BIND; row: PMYSQL_ROW);
  end;

  PMYSQL_STMT = ^MYSQL_STMT;
  MYSQL_STMT = record
    handle:               PMYSQL;
    params:               PMYSQL_BIND;
    result:               PMYSQL_RES;
    bind:                 PMYSQL_BIND;
    fields:               PMYSQL_FIELD;
    list:                 LIST;
    current_row:          PByte;
    last_fetched_buffer:  PByte;
    query:                PChar;
    mem_root:             MEM_ROOT;
    last_fetched_column:  Int64;
    stmt_id:              LongInt;
    last_errno:           Cardinal;
    param_count:          Cardinal;
    field_count:          Cardinal;
    state:                PREP_STMT_STATE;
    last_error:           array[1..MYSQL_ERRMSG_SIZE] of Char;
    sqlstate:             array[1..SQLSTATE_LENGTH + 1] of Char;
    long_alloced:         Byte;
    send_types_to_server: Byte;
    param_buffers:        Byte;
    res_buffers:          Byte;
    result_buffered:      Byte;
  end;

  MYSQL_METHODS = record
    read_query_result: function(handle: PMYSQL): Byte;
    advanced_command:  function(handle: PMYSQL; command: TMySqlServerCommand;
      header: PChar; header_length: LongInt; const arg: PChar;
      arg_length: LongInt; skip_check: Byte): Byte;
    read_rows: function( handle: PMYSQL; mysql_fields: PMYSQL_FIELD;
      fields: Cardinal): PMYSQL_DATA;
    use_result: function(handle: PMYSQL): PMYSQL_RES;
    fetch_lengths: procedure(_to: PLongInt; column: MYSQL_ROW;
      field_count: Cardinal);
    list_fields: function(handle: PMYSQL): PMYSQL_FIELD;
    read_prepare_result: function(handle: PMYSQL; stmt: PMYSQL_STMT): Byte;
    stmt_execute: function(stmt: PMYSQL_STMT): Integer;
    read_binary_rows: function(stmt: PMYSQL_STMT): PMYSQL_DATA;
    unbuffered_fetch: function(handle: PMYSQL; row: PMYSQL_ROW): Integer;
    free_embedded_thd: procedure(handle: PMYSQL);
    read_statisticd: function(handle: PMYSQL): PChar;
  end;

  TModifyType = (MODIFY_INSERT, MODIFY_UPDATE, MODIFY_DELETE);
  TQuoteOptions = (QUOTE_STRIP_CR,QUOTE_STRIP_LF);
  TQuoteOptionsSet = set of TQuoteOptions;

  PMYSQL_MANAGER = ^MYSQL_MANAGER;
  MYSQL_MANAGER = record
    _net:               NET;
    host:               PChar;
    user:               PChar;
    passwd:             PChar;
    port:               Cardinal;
    free_me:            Byte;
    eof:                Byte;
    cmd_status:         Integer;
    last_errno:         Integer;
    net_buf:            PChar;
    net_buf_pos:        PChar;
    net_data_end:       PChar;
    net_buf_size:       Integer;
    last_error:         array[1..MAX_MYSQL_MANAGER_ERR] of Char;
  end;

  { Options for mysql_set_option }
  TMySqlSetOption = (
    MYSQL_OPTION_MULTI_STATEMENTS_ON,
    MYSQL_OPTION_MULTI_STATEMENTS_OFF
  );

  function mysql_affected_rows(Handle: PMYSQL): Int64; stdcall;
  function mysql_character_set_name(Handle: PMYSQL): PChar; stdcall;
  procedure mysql_close(Handle: PMYSQL); stdcall;
  function mysql_connect(Handle: PMYSQL; const Host, User, Passwd: PChar): PMYSQL; stdcall;
  function mysql_create_db(Handle: PMYSQL; const Db: PChar): Integer; stdcall;
  procedure mysql_data_seek(Result: PMYSQL_RES; Offset: Int64); stdcall;
  procedure mysql_debug(Debug: PChar); stdcall;
  function mysql_drop_db(Handle: PMYSQL; const Db: PChar): Integer; stdcall;
  function mysql_dump_debug_info(Handle: PMYSQL): Integer; stdcall;
  function mysql_eof(Result: PMYSQL_RES): Byte; stdcall;
  function mysql_errno(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_error(Handle: PMYSQL): PChar; stdcall;
  function mysql_escape_string(PTo, PFrom: PChar; Len: Cardinal): Cardinal; stdcall;
  function mysql_fetch_field(Result: PMYSQL_RES): PMYSQL_FIELD; stdcall;
  function mysql_fetch_field_direct(Result: PMYSQL_RES; FieldNo: Cardinal): PMYSQL_FIELD; stdcall;
  function mysql_fetch_fields(Result: PMYSQL_RES): PMYSQL_FIELD; stdcall;
  function mysql_fetch_lengths(Result: PMYSQL_RES): PLongInt; stdcall;
  function mysql_fetch_row(Result: PMYSQL_RES): PMYSQL_ROW; stdcall;
  function mysql_field_seek(Result: PMYSQL_RES; Offset: MYSQL_FIELD_OFFSET): MYSQL_FIELD_OFFSET; stdcall;
  function mysql_field_tell(Result: PMYSQL_RES): MYSQL_FIELD_OFFSET; stdcall;
  procedure mysql_free_result(Result: PMYSQL_RES); stdcall;
  function mysql_get_client_info: PChar; stdcall;
  function mysql_get_host_info(Handle: PMYSQL): PChar; stdcall;
  function mysql_get_proto_info(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_get_server_info(Handle: PMYSQL): PChar; stdcall;
  function mysql_info(Handle: PMYSQL): PChar; stdcall;
  function mysql_init(Handle: PMYSQL): PMYSQL; stdcall;
  function mysql_insert_id(Handle: PMYSQL): Int64; stdcall;
  function mysql_kill(Handle: PMYSQL; Pid: LongInt): Integer; stdcall;
  function mysql_list_dbs(Handle: PMYSQL; Wild: PChar): PMYSQL_RES; stdcall;
  function mysql_list_fields(Handle: PMYSQL; const Table, Wild: PChar): PMYSQL_RES; stdcall;
  function mysql_list_processes(Handle: PMYSQL): PMYSQL_RES; stdcall;
  function mysql_list_tables(Handle: PMYSQL; const Wild: PChar): PMYSQL_RES; stdcall;
  function mysql_num_fields(Result: PMYSQL_RES): Cardinal; stdcall;
  function mysql_num_rows(Result: PMYSQL_RES): Int64; stdcall;
  function mysql_options(Handle: PMYSQL; Option: TMySqlOption; const Arg: PChar): Integer; stdcall;
  function mysql_ping(Handle: PMYSQL): Integer; stdcall;
  function mysql_query(Handle: PMYSQL; const Query: PChar): Integer; stdcall;
  function mysql_real_connect(Handle: PMYSQL; const Host, User, Passwd, Db: PChar; Port: Cardinal; const UnixSocket: PChar; ClientFlag: Cardinal): PMYSQL; stdcall;
  function mysql_real_escape_string(Handle: PMYSQL; PTo: PChar; const PFrom: PChar; length: Cardinal): Cardinal; stdcall;
  function mysql_real_query(Handle: PMYSQL; const Query: PChar; Length: Cardinal): Integer;stdcall;
  function mysql_refresh(Handle: PMYSQL; Options: Cardinal): Integer; stdcall;
  function mysql_row_seek(Result: PMYSQL_RES; Offset: PMYSQL_ROWS): PMYSQL_ROWS; stdcall;
  function mysql_row_tell(Result: PMYSQL_RES): PMYSQL_ROWS; stdcall;
  function mysql_select_db(Handle: PMYSQL; const Db: PChar): Integer; stdcall;
  function mysql_ssl_set(Handle: PMYSQL; const key, cert, CA, CApath, cipher:PChar): Byte; stdcall;
  function mysql_stat(Handle: PMYSQL): PChar; stdcall;
  function mysql_store_result(Handle: PMYSQL): PMYSQL_RES; stdcall;
  function mysql_thread_id(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_use_result(Handle: PMYSQL): PMYSQL_RES; stdcall;
  procedure my_init; stdcall;
  function mysql_thread_init: Byte; stdcall;
  procedure mysql_thread_end; stdcall;
  function mysql_thread_safe: Cardinal; stdcall;
  function mysql_server_init(Argc: Integer; Argv, Groups: Pointer): Integer; stdcall;
  procedure mysql_server_end; stdcall;
  function mysql_change_user(mysql: PMYSQL; const user: PChar; const passwd: PChar; const db: PChar): Byte;
  function mysql_field_count(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_get_client_version: Cardinal; stdcall;
  function mysql_send_query(mysql: PMYSQL; const query: PChar;length: Cardinal): Integer; stdcall;
  function mysql_read_query_result(mysql: PMYSQL): Integer; stdcall;
  function mysql_master_query(mysql: PMYSQL; const query: PChar;length: Cardinal): Byte; stdcall;
  function mysql_master_send_query(mysql: PMYSQL; const query: PChar; length: Cardinal): Byte; stdcall;
  function mysql_slave_query(mysql: PMYSQL; const query: PChar; length: Cardinal): Byte; stdcall;
  function mysql_slave_send_query(mysql: PMYSQL; const query: PChar; length: Cardinal): Byte; stdcall;
  procedure mysql_enable_rpl_parse(mysql: PMYSQL); stdcall;
  procedure mysql_disable_rpl_parse(mysql: PMYSQL); stdcall;
  function mysql_rpl_parse_enabled(mysql: PMYSQL): Integer; stdcall;
  procedure mysql_enable_reads_from_master(mysql: PMYSQL); stdcall;
  procedure mysql_disable_reads_from_master(mysql: PMYSQL); stdcall;
  function mysql_reads_from_master_enabled(mysql: PMYSQL): Byte; stdcall;
  function mysql_rpl_query_type(const query: PChar; len: Integer): TMySqlRplType; stdcall;
  function mysql_rpl_probe(mysql: PMYSQL): Byte; stdcall;
  function mysql_set_master(mysql: PMYSQL; const host: PChar; port: Cardinal; const user: PChar; const passwd: PChar): Integer; stdcall;
  function mysql_add_slave(mysql: PMYSQL; const host: PChar; port: Cardinal; const user: PChar; const passwd: PChar): Integer; stdcall;
  function mysql_manager_init(con: PMYSQL_MANAGER): PMYSQL_MANAGER; stdcall;
  function mysql_manager_connect(con: PMYSQL_MANAGER; const host: PChar; const user: PChar; const passwd: PChar; port: Cardinal): PMYSQL_MANAGER; stdcall;
  procedure mysql_manager_close(con: PMYSQL_MANAGER); stdcall;
  function mysql_manager_command(con: PMYSQL_MANAGER; const cmd: PChar; cmd_len: Integer): Integer; stdcall;
  function mysql_manager_fetch_line(con: PMYSQL_MANAGER; res_buf: PChar; res_buf_size: Integer): Integer; stdcall;
  function mysql_autocommit(Handle: PMYSQL; const mode: Byte): Byte; stdcall;
  function mysql_commit(Handle: PMYSQL): Byte; stdcall;
  function mysql_get_server_version(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_hex_string(PTo, PFrom: Pchar; Len: Cardinal): Cardinal; stdcall;
  function mysql_more_results(Handle: PMYSQL): Byte; stdcall;
  function mysql_next_result(Handle: PMYSQL): Integer; stdcall;
  function mysql_rollback(Handle: PMYSQL): Byte; stdcall;
  function mysql_set_character_set(Handle: PMYSQL; csname: PChar): Integer; stdcall;
  function mysql_set_server_option(Handle: PMYSQL; Option: TMysqlSetOption): Integer; stdcall;
  function mysql_shutdown(Handle: PMYSQL; shutdown_level: TMysqlShutdownLevel): Integer;
  function mysql_sqlstate(Handle: PMYSQL): PChar; stdcall;
  function mysql_warning_count(Handle: PMYSQL): Cardinal; stdcall;
  function mysql_stmt_affected_rows(stmt: PMYSQL_STMT): Int64; stdcall;
  function mysql_stmt_attr_get(stmt: PMYSQL_STMT; option: TMysqlStmtAttrType; arg: PChar): Integer; stdcall;
  function mysql_stmt_attr_set(stmt: PMYSQL_STMT; option: TMysqlStmtAttrType; const arg: PChar): Integer; stdcall;
  function mysql_stmt_bind_param(stmt: PMYSQL_STMT; bind: PMYSQL_BIND2): Byte; stdcall;
  function mysql_stmt_bind_result(stmt: PMYSQL_STMT; bind: PMYSQL_BIND2): Byte; stdcall;
  function mysql_stmt_close(stmt: PMYSQL_STMT): Byte; stdcall;
  procedure mysql_stmt_data_seek(stmt: PMYSQL_STMT; offset: Int64); stdcall;
  function mysql_stmt_errno(stmt: PMYSQL_STMT): Cardinal; stdcall;
  function mysql_stmt_error(stmt: PMYSQL_STMT): PChar; stdcall;
  function mysql_stmt_execute(stmt: PMYSQL_STMT): Integer; stdcall;
  function mysql_stmt_fetch(stmt: PMYSQL_STMT): Integer; stdcall;
  function mysql_stmt_fetch_column(stmt: PMYSQL_STMT; bind: PMYSQL_BIND2; column: Cardinal; offset: Cardinal): Integer; stdcall;
  function mysql_stmt_field_count(stmt: PMYSQL_STMT): Cardinal; stdcall;
  function mysql_stmt_free_result(stmt: PMYSQL_STMT): Byte; stdcall;
  function mysql_stmt_init(Handle: PMYSQL): PMYSQL_STMT; stdcall;
  function mysql_stmt_insert_id(stmt: PMYSQL_STMT): Int64; stdcall;
  function mysql_stmt_num_rows(stmt: PMYSQL_STMT): Int64; stdcall;
  function mysql_stmt_param_count(stmt: PMYSQL_STMT): Cardinal; stdcall;
  function mysql_stmt_param_metadata(stmt: PMYSQL_STMT): PMYSQL_RES; stdcall;
  function mysql_stmt_prepare(stmt: PMYSQL_STMT; const query: PChar; length: Cardinal): Integer; stdcall;
  function mysql_stmt_reset(stmt: PMYSQL_STMT): Byte; stdcall;
  function mysql_stmt_result_metadata(stmt: PMYSQL_STMT): PMYSQL_RES; stdcall;
  function mysql_stmt_row_seek(stmt: PMYSQL_STMT; offset: PMYSQL_ROWS): PMYSQL_ROWS; stdcall;
  function mysql_stmt_row_tell(stmt: PMYSQL_STMT): PMYSQL_ROWS; stdcall;
  function mysql_stmt_send_long_data(stmt: PMYSQL_STMT; parameter_number: Cardinal; const data: PChar; length: Cardinal): Byte; stdcall;
  function mysql_stmt_sqlstate(stmt: PMYSQL_STMT): PChar; stdcall;
  function mysql_stmt_store_result(stmt: PMYSQL_STMT): Integer; stdcall;
  procedure mysql_get_character_set_info(Handle: PMYSQL; cs: PMY_CHARSET_INFO); stdcall;

implementation

const
  MYSQLDLL = 'libmysql.dll';

  function mysql_affected_rows; external MYSQLDLL;
  function mysql_character_set_name; external MYSQLDLL;
  procedure mysql_close; external MYSQLDLL;
  function mysql_connect; external MYSQLDLL;
  function mysql_create_db; external MYSQLDLL;
  procedure mysql_data_seek; external MYSQLDLL;
  procedure mysql_debug; external MYSQLDLL;
  function mysql_drop_db; external MYSQLDLL;
  function mysql_dump_debug_info; external MYSQLDLL;
  function mysql_eof; external MYSQLDLL;
  function mysql_errno; external MYSQLDLL;
  function mysql_error; external MYSQLDLL;
  function mysql_escape_string; external MYSQLDLL;
  function mysql_fetch_field; external MYSQLDLL;
  function mysql_fetch_field_direct; external MYSQLDLL;
  function mysql_fetch_fields; external MYSQLDLL;
  function mysql_fetch_lengths; external MYSQLDLL;
  function mysql_fetch_row; external MYSQLDLL;
  function mysql_field_seek; external MYSQLDLL;
  function mysql_field_tell; external MYSQLDLL;
  procedure mysql_free_result; external MYSQLDLL;
  function mysql_get_client_info; external MYSQLDLL;
  function mysql_get_host_info; external MYSQLDLL;
  function mysql_get_proto_info; external MYSQLDLL;
  function mysql_get_server_info; external MYSQLDLL;
  function mysql_info; external MYSQLDLL;
  function mysql_init; external MYSQLDLL;
  function mysql_insert_id; external MYSQLDLL;
  function mysql_kill; external MYSQLDLL;
  function mysql_list_dbs; external MYSQLDLL;
  function mysql_list_fields; external MYSQLDLL;
  function mysql_list_processes; external MYSQLDLL;
  function mysql_list_tables; external MYSQLDLL;
  function mysql_num_fields; external MYSQLDLL;
  function mysql_num_rows; external MYSQLDLL;
  function mysql_options; external MYSQLDLL;
  function mysql_ping; external MYSQLDLL;
  function mysql_query; external MYSQLDLL;
  function mysql_real_connect; external MYSQLDLL;
  function mysql_real_escape_string; external MYSQLDLL;
  function mysql_real_query; external MYSQLDLL;
  function mysql_refresh; external MYSQLDLL;
  function mysql_row_seek; external MYSQLDLL;
  function mysql_row_tell; external MYSQLDLL;
  function mysql_select_db; external MYSQLDLL;
  function mysql_ssl_set; external MYSQLDLL;
  function mysql_stat; external MYSQLDLL;
  function mysql_store_result; external MYSQLDLL;
  function mysql_thread_id; external MYSQLDLL;
  function mysql_use_result; external MYSQLDLL;
  procedure my_init; external MYSQLDLL;
  function mysql_thread_init; external MYSQLDLL;
  procedure mysql_thread_end; external MYSQLDLL;
  function mysql_thread_safe; external MYSQLDLL;
  function mysql_server_init; external MYSQLDLL;
  procedure mysql_server_end; external MYSQLDLL;
  function mysql_change_user; external MYSQLDLL;
  function mysql_field_count; external MYSQLDLL;
  function mysql_get_client_version; external MYSQLDLL;
  function mysql_send_query; external MYSQLDLL;
  function mysql_read_query_result; external MYSQLDLL;
  function mysql_master_query; external MYSQLDLL;
  function mysql_master_send_query; external MYSQLDLL;
  function mysql_slave_query; external MYSQLDLL;
  function mysql_slave_send_query; external MYSQLDLL;
  procedure mysql_enable_rpl_parse; external MYSQLDLL;
  procedure mysql_disable_rpl_parse; external MYSQLDLL;
  function mysql_rpl_parse_enabled; external MYSQLDLL;
  procedure mysql_enable_reads_from_master; external MYSQLDLL;
  procedure mysql_disable_reads_from_master; external MYSQLDLL;
  function mysql_reads_from_master_enabled; external MYSQLDLL;
  function mysql_rpl_query_type; external MYSQLDLL;
  function mysql_rpl_probe; external MYSQLDLL;
  function mysql_set_master; external MYSQLDLL;
  function mysql_add_slave; external MYSQLDLL;
  function mysql_manager_init; external MYSQLDLL;
  function mysql_manager_connect; external MYSQLDLL;
  procedure mysql_manager_close; external MYSQLDLL;
  function mysql_manager_command; external MYSQLDLL;
  function mysql_manager_fetch_line; external MYSQLDLL;
  function mysql_autocommit; external MYSQLDLL;
  function mysql_commit; external MYSQLDLL;
  function mysql_get_server_version; external MYSQLDLL;
  function mysql_hex_string; external MYSQLDLL;
  function mysql_more_results; external MYSQLDLL;
  function mysql_next_result; external MYSQLDLL;
  function mysql_rollback; external MYSQLDLL;
  function mysql_set_character_set; external MYSQLDLL;
  function mysql_set_server_option; external MYSQLDLL;
  function mysql_shutdown; external MYSQLDLL;
  function mysql_sqlstate; external MYSQLDLL;
  function mysql_warning_count; external MYSQLDLL;
  function mysql_stmt_affected_rows; external MYSQLDLL;
  function mysql_stmt_attr_get; external MYSQLDLL;
  function mysql_stmt_attr_set; external MYSQLDLL;
  function mysql_stmt_bind_param; external MYSQLDLL;
  function mysql_stmt_bind_result; external MYSQLDLL;
  function mysql_stmt_close; external MYSQLDLL;
  procedure mysql_stmt_data_seek; external MYSQLDLL;
  function mysql_stmt_errno; external MYSQLDLL;
  function mysql_stmt_error; external MYSQLDLL;
  function mysql_stmt_execute; external MYSQLDLL;
  function mysql_stmt_fetch; external MYSQLDLL;
  function mysql_stmt_fetch_column; external MYSQLDLL;
  function mysql_stmt_field_count; external MYSQLDLL;
  function mysql_stmt_free_result; external MYSQLDLL;
  function mysql_stmt_init; external MYSQLDLL;
  function mysql_stmt_insert_id; external MYSQLDLL;
  function mysql_stmt_num_rows; external MYSQLDLL;
  function mysql_stmt_param_count; external MYSQLDLL;
  function mysql_stmt_param_metadata; external MYSQLDLL;
  function mysql_stmt_prepare; external MYSQLDLL;
  function mysql_stmt_reset; external MYSQLDLL;
  function mysql_stmt_result_metadata; external MYSQLDLL;
  function mysql_stmt_row_seek; external MYSQLDLL;
  function mysql_stmt_row_tell; external MYSQLDLL;
  function mysql_stmt_send_long_data; external MYSQLDLL;
  function mysql_stmt_sqlstate; external MYSQLDLL;
  function mysql_stmt_store_result; external MYSQLDLL;
  procedure mysql_get_character_set_info; external MYSQLDLL;

end.

