{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXTableStorage;
interface
uses
  SysUtils;
type
  TDBXColumnDescriptor = class;
  TDBXColumnDescriptorArray = array of TDBXColumnDescriptor;

  TDBXColumnDescriptor = class
  public
    constructor Create(const ColumnName: WideString; const ColumnCaption: WideString; const ColumnType: Integer); overload;
    constructor Create(const ColumnName: WideString; const ColumnCaption: WideString; const ColumnType: Integer; const Hidden: Boolean); overload;
    constructor Create(const ColumnName: WideString; const ColumnType: Integer; const DataSize: Integer); overload;
    constructor Create(Descriptor: TDBXColumnDescriptor); overload;
  private
    function DefaultDataSize(ColumnType: Integer): Integer;
  private
    FColumnType: Integer;
    FDataSize: Integer;
    FColumnName: WideString;
    FColumnCaption: WideString;
    FHidden: Boolean;
  public
    property ColumnType: Integer read FColumnType write FColumnType;
    property DataSize: Integer read FDataSize write FDataSize;
    property ColumnCaption: WideString read FColumnCaption write FColumnCaption;
    property ColumnName: WideString read FColumnName write FColumnName;
    property Hidden: Boolean read FHidden write FHidden;
  private
    const DefaultAnsiDataSize = 128;
    const DefaultWideDataSize = 256;
  end;

  TDBXRowStorage = class abstract
  public
    function CopyColumns: TDBXColumnDescriptorArray; virtual; abstract;
    function FindOrdinal(const ColumnName: WideString): Integer; virtual; abstract;
    
    /// <summary> Copies a value from a given ordinal to a target storage.
    /// </summary>
    /// <remarks> This method should take care of NULL values and neccessary conversions.
    /// 
    /// </remarks>
    /// <param name="ordinal">int       Source ordinal.</param>
    /// <param name="target">RowStorage Where the value is to be copied to.</param>
    /// <param name="targetOrdinal">int The ordinal in the target RowStorage.</param>
    procedure CopyTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer); virtual; abstract;
    
    /// <summary> Checks if a value from a given ordinal is the same as the value in the target row.
    /// </summary>
    /// <param name="ordinal">int</param>
    /// <param name="target">RowStorage</param>
    /// <param name="targetOrdinal">int</param>
    /// <returns>boolean</returns>
    function EqualTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer): Boolean; virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position
    ///  in the table as a byte.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position
    ///                   in the table as a byte.</returns>
    /// <seealso cref="getByte(String)"/>
    function GetUnsignedByte(Ordinal: Integer): SmallInt; overload; virtual; abstract;
    function GetUnsignedByte(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; virtual; abstract;
    function GetAsUnsignedByte(Ordinal: Integer): SmallInt; virtual; abstract;
    procedure SetUnsignedByte(Ordinal: Integer; Value: SmallInt); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position
    ///  in the table as a byte.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position
    ///                   in the table as a byte.</returns>
    /// <seealso cref="getByte(String)"/>
    function GetByte(Ordinal: Integer): Byte; overload; virtual; abstract;
    function GetByte(Ordinal: Integer; DefaultValue: Byte): Byte; overload; virtual; abstract;
    function GetAsByte(Ordinal: Integer): Byte; virtual; abstract;
    procedure SetByte(Ordinal: Integer; Value: Byte); virtual; abstract;
    
    /// <summary>  Returns the value in the Column indicated by its ordinal position in the table as a short.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the table as a short.</returns>
    /// <seealso cref="getShort(String)"/>
    function GetInt16(Ordinal: Integer): SmallInt; overload; virtual; abstract;
    function GetInt16(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; virtual; abstract;
    function GetAsInt16(Ordinal: Integer): SmallInt; virtual; abstract;
    procedure SetInt16(Ordinal: Integer; Value: SmallInt); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in
    ///  the table as an int.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in
    ///                 the table as an int.</returns>
    /// <seealso cref="getInt(String)"/>
    function GetInt32(Ordinal: Integer): Integer; overload; virtual; abstract;
    function GetInt32(Ordinal: Integer; DefaultValue: Integer): Integer; overload; virtual; abstract;
    function GetAsInt32(Ordinal: Integer): Integer; virtual; abstract;
    procedure SetInt32(Ordinal: Integer; Value: Integer); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in the
    ///  table as a long.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal"></param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                   table as a long.</returns>
    /// <seealso cref="getLong(String)"/>
    function GetInt64(Ordinal: Integer): Int64; overload; virtual; abstract;
    function GetInt64(Ordinal: Integer; DefaultValue: Int64): Int64; overload; virtual; abstract;
    function GetAsInt64(Ordinal: Integer): Int64; virtual; abstract;
    procedure SetInt64(Ordinal: Integer; Value: Int64); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in the
    ///  table as a boolean.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <seealso cref="getBoolean(java.lang.String)"/>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                   table as a boolean.</returns>
    function GetBoolean(Ordinal: Integer): Boolean; overload; virtual; abstract;
    function GetBoolean(Ordinal: Integer; DefaultValue: Boolean): Boolean; overload; virtual; abstract;
    function GetAsBoolean(Ordinal: Integer): Boolean; virtual; abstract;
    procedure SetBoolean(Ordinal: Integer; Value: Boolean); virtual; abstract;
    
    /// <summary>  Returns the value in the Column indicated by its ordinal position in the
    ///   table as a float.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                     table as a float.</returns>
    function GetFloat(Ordinal: Integer): Single; overload; virtual; abstract;
    function GetFloat(Ordinal: Integer; DefaultValue: Single): Single; overload; virtual; abstract;
    function GetAsFloat(Ordinal: Integer): Single; virtual; abstract;
    procedure SetFloat(Ordinal: Integer; Value: Single); virtual; abstract;
    
    /// <summary>  Returns the value in the Column indicated by its ordinal position in the
    ///   table as a double.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                     table as a double.</returns>
    function GetDouble(Ordinal: Integer): Double; overload; virtual; abstract;
    function GetDouble(Ordinal: Integer; DefaultValue: Double): Double; overload; virtual; abstract;
    function GetAsDouble(Ordinal: Integer): Double; virtual; abstract;
    procedure SetDouble(Ordinal: Integer; Value: Double); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in
    ///  the table as a String.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in
    ///                     the table as a String.</returns>
    /// <seealso cref="getString(String)"/>
    function GetString(Ordinal: Integer): WideString; overload; virtual; abstract;
    function GetString(Ordinal: Integer; const DefaultValue: WideString): WideString; overload; virtual; abstract;
    function GetAsString(Ordinal: Integer): WideString; virtual; abstract;
    procedure SetString(Ordinal: Integer; const Value: WideString); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in the
    ///  table as a Decimal object.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position of the Column in the table.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                 table as a Decimal.</returns>
    function GetDecimal(Ordinal: Integer): TObject; overload; virtual; abstract;
    function GetDecimal(Ordinal: Integer; DefaultValue: TObject): TObject; overload; virtual; abstract;
    function GetAsDecimal(Ordinal: Integer): TObject; virtual; abstract;
    procedure SetDecimal(Ordinal: Integer; Value: TObject); virtual; abstract;
    
    /// <summary>  Returns the value in the Column indicated by its ordinal position in the
    ///   table as a Timestamp.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                   table as a Timestamp.</returns>
    function GetTimestamp(Ordinal: Integer): TObject; virtual; abstract;
    function GetAsTimestamp(Ordinal: Integer): TObject; virtual; abstract;
    procedure SetTimestamp(Ordinal: Integer; Value: TObject); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in
    ///  the table as an Stream.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position
    ///                   in the table as a Stream.</returns>
    function GetStream(Ordinal: Integer): TObject; virtual; abstract;
    function GetAsStream(Ordinal: Integer): TObject; virtual; abstract;
    procedure SetStream(Ordinal: Integer; Value: TObject); virtual; abstract;
    
    /// <summary>  Get field value as a byte array.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns></returns>
    function GetByteArray(Ordinal: Integer): TBytes; virtual; abstract;
    function GetAsByteArray(Ordinal: Integer): TBytes; virtual; abstract;
    procedure SetByteArray(Ordinal: Integer; Value: TBytes); virtual; abstract;
    
    /// <summary> Returns the value in the Column indicated by its ordinal position in the
    ///  table as an Object.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="ordinal">The position in the table containing the value in the Column.</param>
    /// <returns>The value in the Column indicated by its ordinal position in the
    ///                   table as an Object.</returns>
    /// <seealso cref="getObject(String)"/>
    function GetObject(Ordinal: Integer): TObject; overload; virtual; abstract;
    function GetObject(Ordinal: Integer; DefaultValue: TObject): TObject; overload; virtual; abstract;
    procedure SetObject(Ordinal: Integer; Value: TObject); virtual; abstract;
    
    /// <summary>  Returns <b>true</b> if the value at the specified ordinal is either an assigned or
    ///   unassigned null; <b>false</b> otherwise.
    /// </summary>
    /// <remarks> To determine if the value is an unassigned null,
    ///   call the <see cref="isUnassignedNull(int)"/> method.
    /// 
    /// </remarks>
    /// <param name="ordinal">The ordinal containing the value.</param>
    /// <returns><b>true</b> if the value at the specified ordinal is either an assigned or
    ///                   unassigned null; <b>false</b> otherwise.</returns>
    function IsNull(Ordinal: Integer): Boolean; virtual; abstract;
    procedure SetNull(Ordinal: Integer); virtual; abstract;
    
    /// <summary> Determines whether the data value at location ordinal is an assigned null value.
    /// </summary>
    /// <remarks> If it returns <b>true</b>, the value is an assigned null value; otherwise,
    ///  it is not and returns <b>false</b>.
    /// 
    /// </remarks>
    /// <param name="ordinal">The location ordinal of the data.</param>
    /// <returns><b>true</b> if the value is an assigned null value; otherwise,
    ///                 it is not and returns <b>false</b>.</returns>
    function IsAssignedNull(Ordinal: Integer): Boolean; virtual; abstract;
    
    /// <summary> Determines whether the data value at location ordinal is an assigned null value.
    /// </summary>
    /// <remarks> If it returns <b>true</b>, the value is an assigned null value; otherwise, it is not
    ///  and returns <b>false</b>.
    /// 
    /// </remarks>
    /// <param name="ordinal">The location ordinal of the data.</param>
    /// <returns><b>true</b> if the value is an assigned null value; otherwise,
    ///                 it returns <b>false</b>.</returns>
    function IsUnassignedNull(Ordinal: Integer): Boolean; virtual; abstract;
  protected
    function GetColumns: TDBXColumnDescriptorArray; virtual; abstract;
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); virtual; abstract;
    function GetMetaDataCollectionName: WideString; virtual; abstract;
    function GetMetaDataCollectionIndex: Integer; virtual; abstract;
    
    /// <summary> Get the original values for this row.
    /// </summary>
    /// <returns>RowStorage</returns>
    function GetOriginalRow: TDBXRowStorage; virtual; abstract;
    procedure SetAssignedNull(Ordinal: Integer); virtual; abstract;
    procedure SetUnassignedNull(Ordinal: Integer); virtual; abstract;
  public
    property Columns: TDBXColumnDescriptorArray read GetColumns write SetColumns;
    property MetaDataCollectionName: WideString read GetMetaDataCollectionName;
    property MetaDataCollectionIndex: Integer read GetMetaDataCollectionIndex;
    
    /// <summary> Get the original values for this row.
    /// </summary>
    /// <returns>RowStorage</returns>
    property OriginalRow: TDBXRowStorage read GetOriginalRow;
    property AssignedNull: Integer write SetAssignedNull;
    property UnassignedNull: Integer write SetUnassignedNull;
  end;

  TDBXDefaultRowStorage = class(TDBXRowStorage)
  public
    function CopyColumns: TDBXColumnDescriptorArray; override;
    function FindOrdinal(const ColumnName: WideString): Integer; override;
    procedure CopyTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer); override;
    function EqualTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer): Boolean; override;
    function GetByte(Ordinal: Integer): Byte; overload; override;
    function GetByte(Ordinal: Integer; DefaultValue: Byte): Byte; overload; override;
    function GetAsByte(Ordinal: Integer): Byte; override;
    procedure SetByte(Ordinal: Integer; Value: Byte); override;
    function GetUnsignedByte(Ordinal: Integer): SmallInt; overload; override;
    function GetUnsignedByte(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; override;
    function GetAsUnsignedByte(Ordinal: Integer): SmallInt; override;
    procedure SetUnsignedByte(Ordinal: Integer; Value: SmallInt); override;
    function GetInt16(Ordinal: Integer): SmallInt; overload; override;
    function GetInt16(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; override;
    function GetAsInt16(Ordinal: Integer): SmallInt; override;
    procedure SetInt16(Ordinal: Integer; Value: SmallInt); override;
    function GetInt32(Ordinal: Integer): Integer; overload; override;
    function GetInt32(Ordinal: Integer; DefaultValue: Integer): Integer; overload; override;
    function GetAsInt32(Ordinal: Integer): Integer; override;
    procedure SetInt32(Ordinal: Integer; Value: Integer); override;
    function GetInt64(Ordinal: Integer): Int64; overload; override;
    function GetInt64(Ordinal: Integer; DefaultValue: Int64): Int64; overload; override;
    function GetAsInt64(Ordinal: Integer): Int64; override;
    procedure SetInt64(Ordinal: Integer; Value: Int64); override;
    function GetBoolean(Ordinal: Integer): Boolean; overload; override;
    function GetBoolean(Ordinal: Integer; DefaultValue: Boolean): Boolean; overload; override;
    function GetAsBoolean(Ordinal: Integer): Boolean; override;
    procedure SetBoolean(Ordinal: Integer; Value: Boolean); override;
    function GetFloat(Ordinal: Integer): Single; overload; override;
    function GetFloat(Ordinal: Integer; DefaultValue: Single): Single; overload; override;
    function GetAsFloat(Ordinal: Integer): Single; override;
    procedure SetFloat(Ordinal: Integer; Value: Single); override;
    function GetDouble(Ordinal: Integer): Double; overload; override;
    function GetDouble(Ordinal: Integer; DefaultValue: Double): Double; overload; override;
    function GetAsDouble(Ordinal: Integer): Double; override;
    procedure SetDouble(Ordinal: Integer; Value: Double); override;
    function GetString(Ordinal: Integer): WideString; overload; override;
    function GetString(Ordinal: Integer; const DefaultValue: WideString): WideString; overload; override;
    function GetAsString(Ordinal: Integer): WideString; override;
    procedure SetString(Ordinal: Integer; const Value: WideString); override;
    function GetDecimal(Ordinal: Integer): TObject; overload; override;
    function GetDecimal(Ordinal: Integer; DefaultValue: TObject): TObject; overload; override;
    function GetAsDecimal(Ordinal: Integer): TObject; override;
    procedure SetDecimal(Ordinal: Integer; Value: TObject); override;
    function GetTimestamp(Ordinal: Integer): TObject; override;
    function GetAsTimestamp(Ordinal: Integer): TObject; override;
    procedure SetTimestamp(Ordinal: Integer; Value: TObject); override;
    function GetStream(Ordinal: Integer): TObject; override;
    function GetAsStream(Ordinal: Integer): TObject; override;
    procedure SetStream(Ordinal: Integer; Value: TObject); override;
    function GetByteArray(Ordinal: Integer): TBytes; override;
    function GetAsByteArray(Ordinal: Integer): TBytes; override;
    procedure SetByteArray(Ordinal: Integer; Value: TBytes); override;
    function GetObject(Ordinal: Integer): TObject; overload; override;
    function GetObject(Ordinal: Integer; DefaultValue: TObject): TObject; overload; override;
    procedure SetObject(Ordinal: Integer; Value: TObject); override;
    function IsNull(Ordinal: Integer): Boolean; override;
    procedure SetNull(Ordinal: Integer); override;
    function IsAssignedNull(Ordinal: Integer): Boolean; override;
    function IsUnassignedNull(Ordinal: Integer): Boolean; override;
  protected
    function GetColumns: TDBXColumnDescriptorArray; override;
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); override;
    function GetMetaDataCollectionName: WideString; override;
    function GetMetaDataCollectionIndex: Integer; override;
    function GetOriginalRow: TDBXRowStorage; override;
    procedure SetAssignedNull(Ordinal: Integer); override;
    procedure SetUnassignedNull(Ordinal: Integer); override;
  end;

  TDBXTableStorage = class abstract(TDBXDefaultRowStorage)
  public
    procedure BeforeFirst; virtual; abstract;
    function Next: Boolean; virtual; abstract;
    procedure NewRow; virtual; abstract;
    procedure InsertRow; virtual; abstract;
    procedure CopyFrom(const Source: TDBXTableStorage); virtual; abstract;
    procedure Close; virtual; abstract;
    procedure Clear; virtual; abstract;
    procedure DeleteRow; virtual; abstract;
    function FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean; virtual; abstract;
    procedure AcceptChanges; virtual; abstract;
    function GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage; virtual; abstract;
  protected
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); override; abstract;
    function GetStorage: TObject; virtual; abstract;
    function GetCommand: TObject; virtual; abstract;
    procedure SetHiddenColumn(const ColumnName: WideString); virtual; abstract;
    function GetDeletedRows: TDBXTableStorage; virtual; abstract;
    function GetInsertedRows: TDBXTableStorage; virtual; abstract;
    function GetModifiedRows: TDBXTableStorage; virtual; abstract;
  public
    property Storage: TObject read GetStorage;
    property Command: TObject read GetCommand;
    property HiddenColumn: WideString write SetHiddenColumn;
    property DeletedRows: TDBXTableStorage read GetDeletedRows;
    property InsertedRows: TDBXTableStorage read GetInsertedRows;
    property ModifiedRows: TDBXTableStorage read GetModifiedRows;
  end;

  TDBXDefaultTableStorage = class(TDBXTableStorage)
  public
    procedure CopyFrom(const Source: TDBXTableStorage); override;
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure NewRow; override;
    procedure InsertRow; override;
    procedure Close; override;
    procedure Clear; override;
    procedure DeleteRow; override;
    function FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean; override;
    procedure AcceptChanges; override;
    function GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage; override;
  protected
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); override;
    function GetStorage: TObject; override;
    function GetCommand: TObject; override;
    procedure SetHiddenColumn(const ColumnName: WideString); override;
    function GetDeletedRows: TDBXTableStorage; override;
    function GetInsertedRows: TDBXTableStorage; override;
    function GetModifiedRows: TDBXTableStorage; override;
  end;

  TDBXDelegateTableStorage = class(TDBXDefaultTableStorage)
  public
    constructor Create(Table: TDBXTableStorage);
    destructor Destroy; override;
    function ReplaceStorage(Table: TDBXTableStorage): TDBXTableStorage; virtual;
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure NewRow; override;
    procedure InsertRow; override;
    procedure CopyFrom(const Source: TDBXTableStorage); override;
    procedure Close; override;
    procedure Clear; override;
    procedure DeleteRow; override;
    function FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean; override;
    procedure AcceptChanges; override;
    function GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage; override;
    function FindOrdinal(const ColumnName: WideString): Integer; override;
    function EqualTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer): Boolean; override;
    function GetUnsignedByte(Ordinal: Integer): SmallInt; overload; override;
    function GetUnsignedByte(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; override;
    function GetAsUnsignedByte(Ordinal: Integer): SmallInt; override;
    procedure SetUnsignedByte(Ordinal: Integer; Value: SmallInt); override;
    function GetByte(Ordinal: Integer): Byte; overload; override;
    function GetByte(Ordinal: Integer; DefaultValue: Byte): Byte; overload; override;
    function GetAsByte(Ordinal: Integer): Byte; override;
    procedure SetByte(Ordinal: Integer; Value: Byte); override;
    function GetInt16(Ordinal: Integer): SmallInt; overload; override;
    function GetInt16(Ordinal: Integer; DefaultValue: SmallInt): SmallInt; overload; override;
    function GetAsInt16(Ordinal: Integer): SmallInt; override;
    procedure SetInt16(Ordinal: Integer; Value: SmallInt); override;
    function GetInt32(Ordinal: Integer): Integer; overload; override;
    function GetInt32(Ordinal: Integer; DefaultValue: Integer): Integer; overload; override;
    function GetAsInt32(Ordinal: Integer): Integer; override;
    procedure SetInt32(Ordinal: Integer; Value: Integer); override;
    function GetInt64(Ordinal: Integer): Int64; overload; override;
    function GetInt64(Ordinal: Integer; DefaultValue: Int64): Int64; overload; override;
    function GetAsInt64(Ordinal: Integer): Int64; override;
    procedure SetInt64(Ordinal: Integer; Value: Int64); override;
    function GetBoolean(Ordinal: Integer): Boolean; overload; override;
    function GetBoolean(Ordinal: Integer; DefaultValue: Boolean): Boolean; overload; override;
    function GetAsBoolean(Ordinal: Integer): Boolean; override;
    procedure SetBoolean(Ordinal: Integer; Value: Boolean); override;
    function GetFloat(Ordinal: Integer): Single; overload; override;
    function GetFloat(Ordinal: Integer; DefaultValue: Single): Single; overload; override;
    function GetAsFloat(Ordinal: Integer): Single; override;
    procedure SetFloat(Ordinal: Integer; Value: Single); override;
    function GetDouble(Ordinal: Integer): Double; overload; override;
    function GetDouble(Ordinal: Integer; DefaultValue: Double): Double; overload; override;
    function GetAsDouble(Ordinal: Integer): Double; override;
    procedure SetDouble(Ordinal: Integer; Value: Double); override;
    function GetString(Ordinal: Integer): WideString; overload; override;
    function GetString(Ordinal: Integer; const DefaultValue: WideString): WideString; overload; override;
    function GetAsString(Ordinal: Integer): WideString; override;
    procedure SetString(Ordinal: Integer; const Value: WideString); override;
    function GetDecimal(Ordinal: Integer): TObject; overload; override;
    function GetDecimal(Ordinal: Integer; DefaultValue: TObject): TObject; overload; override;
    function GetAsDecimal(Ordinal: Integer): TObject; override;
    procedure SetDecimal(Ordinal: Integer; Value: TObject); override;
    function GetTimestamp(Ordinal: Integer): TObject; override;
    function GetAsTimestamp(Ordinal: Integer): TObject; override;
    procedure SetTimestamp(Ordinal: Integer; Value: TObject); override;
    function GetStream(Ordinal: Integer): TObject; override;
    function GetAsStream(Ordinal: Integer): TObject; override;
    procedure SetStream(Ordinal: Integer; Value: TObject); override;
    function GetByteArray(Ordinal: Integer): TBytes; override;
    function GetAsByteArray(Ordinal: Integer): TBytes; override;
    procedure SetByteArray(Ordinal: Integer; Value: TBytes); override;
    function GetObject(Ordinal: Integer): TObject; overload; override;
    function GetObject(Ordinal: Integer; DefaultValue: TObject): TObject; overload; override;
    procedure SetObject(Ordinal: Integer; Value: TObject); override;
    function IsNull(Ordinal: Integer): Boolean; override;
    procedure SetNull(Ordinal: Integer); override;
    function IsAssignedNull(Ordinal: Integer): Boolean; override;
    function IsUnassignedNull(Ordinal: Integer): Boolean; override;
  protected
    function GetStorage: TObject; override;
    function GetCommand: TObject; override;
    procedure SetHiddenColumn(const ColumnName: WideString); override;
    function GetDeletedRows: TDBXTableStorage; override;
    function GetInsertedRows: TDBXTableStorage; override;
    function GetModifiedRows: TDBXTableStorage; override;
    function GetColumns: TDBXColumnDescriptorArray; override;
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); override;
    function GetMetaDataCollectionName: WideString; override;
    function GetMetaDataCollectionIndex: Integer; override;
    function GetOriginalRow: TDBXRowStorage; override;
    procedure SetAssignedNull(Ordinal: Integer); override;
    procedure SetUnassignedNull(Ordinal: Integer); override;
  protected
    FTable: TDBXTableStorage;
  end;

implementation
uses
  DBXCommon,
  DBXPlatformUtil;

constructor TDBXColumnDescriptor.Create(const ColumnName: WideString; const ColumnCaption: WideString; const ColumnType: Integer);
begin
  inherited Create;
  self.FColumnName := ColumnName;
  self.FColumnCaption := ColumnCaption;
  self.FColumnType := ColumnType;
  self.FDataSize := DefaultDataSize(ColumnType);
end;

constructor TDBXColumnDescriptor.Create(const ColumnName: WideString; const ColumnCaption: WideString; const ColumnType: Integer; const Hidden: Boolean);
begin
  inherited Create;
  self.FColumnName := ColumnName;
  self.FColumnCaption := ColumnCaption;
  self.FColumnType := ColumnType;
  self.FHidden := Hidden;
  self.FDataSize := DefaultDataSize(ColumnType);
end;

constructor TDBXColumnDescriptor.Create(const ColumnName: WideString; const ColumnType: Integer; const DataSize: Integer);
begin
  inherited Create;
  self.FColumnName := ColumnName;
  self.FColumnCaption := ColumnName;
  self.FColumnType := ColumnType;
  self.FDataSize := DataSize;
end;

constructor TDBXColumnDescriptor.Create(Descriptor: TDBXColumnDescriptor);
begin
  inherited Create;
  self.FColumnName := Descriptor.FColumnName;
  self.FColumnCaption := Descriptor.FColumnCaption;
  self.FColumnType := Descriptor.FColumnType;
  self.FDataSize := Descriptor.FDataSize;
  self.FHidden := Descriptor.FHidden;
end;

function TDBXColumnDescriptor.DefaultDataSize(ColumnType: Integer): Integer;
begin
  case ColumnType of
    TDBXDataTypes.BooleanType,
    TDBXDataTypesEx.Int8Type:
      Result := 1;
    TDBXDataTypes.Int16Type:
      Result := 2;
    TDBXDataTypes.Int32Type:
      Result := 4;
    TDBXDataTypes.Int64Type:
      Result := 8;
    TDBXDataTypes.WideStringType:
      Result := DefaultWideDataSize;
    TDBXDataTypes.AnsiStringType:
      Result := DefaultAnsiDataSize;
    else
      Result := 0;
  end;
end;

function TDBXDefaultRowStorage.GetColumns: TDBXColumnDescriptorArray;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.CopyColumns: TDBXColumnDescriptorArray;
var
  CurrentColumns: TDBXColumnDescriptorArray;
  CopyColumns: TDBXColumnDescriptorArray;
  Ordinal: Integer;
begin
  CurrentColumns := Columns;
  SetLength(CopyColumns,Length(CurrentColumns));
  for ordinal := 0 to Length(CurrentColumns) - 1 do
    CopyColumns[Ordinal] := TDBXColumnDescriptor.Create(CurrentColumns[Ordinal]);
  Result := CopyColumns;
end;

procedure TDBXDefaultRowStorage.SetColumns(const Columns: TDBXColumnDescriptorArray);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetMetaDataCollectionName: WideString;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetMetaDataCollectionIndex: Integer;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetOriginalRow: TDBXRowStorage;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.FindOrdinal(const ColumnName: WideString): Integer;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultRowStorage.CopyTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer);
begin
  if IsNull(Ordinal) then
    Target.SetNull(TargetOrdinal)
  else 
    case Target.Columns[TargetOrdinal].ColumnType of
      TDBXDataTypes.BooleanType:
        Target.SetBoolean(TargetOrdinal, GetAsBoolean(Ordinal));
      TDBXDataTypes.Int16Type:
        Target.SetInt16(TargetOrdinal, GetAsInt16(Ordinal));
      TDBXDataTypes.Int32Type:
        Target.SetInt32(TargetOrdinal, GetAsInt32(Ordinal));
      TDBXDataTypes.Int64Type:
        Target.SetInt64(TargetOrdinal, GetAsInt64(Ordinal));
      TDBXDataTypes.WideStringType:
        Target.SetString(TargetOrdinal, GetAsString(Ordinal));
      else
        raise Exception.Create(SUnsupportedOperation);
    end;
end;

function TDBXDefaultRowStorage.EqualTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer): Boolean;
var
  Obj1: TObject;
begin
  Obj1 := GetObject(Ordinal);
  if Obj1 = nil then
    Result := Target.IsNull(TargetOrdinal)
  else 
    Result := ObjectEquals(Obj1,Target.GetObject(TargetOrdinal));
end;

function TDBXDefaultRowStorage.GetByte(Ordinal: Integer): Byte;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetByte(Ordinal: Integer; DefaultValue: Byte): Byte;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetByte(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsByte(Ordinal: Integer): Byte;
begin
  Result := GetByte(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetByte(Ordinal: Integer; Value: Byte);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetUnsignedByte(Ordinal: Integer): SmallInt;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetUnsignedByte(Ordinal: Integer; DefaultValue: SmallInt): SmallInt;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetUnsignedByte(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsUnsignedByte(Ordinal: Integer): SmallInt;
begin
  Result := GetUnsignedByte(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetUnsignedByte(Ordinal: Integer; Value: SmallInt);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt16(Ordinal: Integer; DefaultValue: SmallInt): SmallInt;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetInt16(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsInt16(Ordinal: Integer): SmallInt;
begin
  Result := GetInt16(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetInt16(Ordinal: Integer; Value: SmallInt);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt32(Ordinal: Integer): Integer;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt32(Ordinal: Integer; DefaultValue: Integer): Integer;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetInt32(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsInt32(Ordinal: Integer): Integer;
begin
  Result := GetInt32(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetInt32(Ordinal: Integer; Value: Integer);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt64(Ordinal: Integer): Int64;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetInt64(Ordinal: Integer; DefaultValue: Int64): Int64;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetInt64(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsInt64(Ordinal: Integer): Int64;
begin
  Result := GetInt64(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetInt64(Ordinal: Integer; Value: Int64);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetBoolean(Ordinal: Integer; DefaultValue: Boolean): Boolean;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetBoolean(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsBoolean(Ordinal: Integer): Boolean;
begin
  Result := GetBoolean(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetBoolean(Ordinal: Integer; Value: Boolean);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetFloat(Ordinal: Integer): Single;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetFloat(Ordinal: Integer; DefaultValue: Single): Single;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetFloat(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsFloat(Ordinal: Integer): Single;
begin
  Result := GetFloat(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetFloat(Ordinal: Integer; Value: Single);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetDouble(Ordinal: Integer): Double;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetDouble(Ordinal: Integer; DefaultValue: Double): Double;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetDouble(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsDouble(Ordinal: Integer): Double;
begin
  Result := GetDouble(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetDouble(Ordinal: Integer; Value: Double);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetString(Ordinal: Integer): WideString;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetString(Ordinal: Integer; const DefaultValue: WideString): WideString;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetString(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsString(Ordinal: Integer): WideString;
begin
  Result := GetString(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetString(Ordinal: Integer; const Value: WideString);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetDecimal(Ordinal: Integer): TObject;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetDecimal(Ordinal: Integer; DefaultValue: TObject): TObject;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetDecimal(Ordinal);
end;

function TDBXDefaultRowStorage.GetAsDecimal(Ordinal: Integer): TObject;
begin
  Result := GetAsDecimal(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetDecimal(Ordinal: Integer; Value: TObject);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetTimestamp(Ordinal: Integer): TObject;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetAsTimestamp(Ordinal: Integer): TObject;
begin
  Result := GetTimestamp(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetTimestamp(Ordinal: Integer; Value: TObject);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetStream(Ordinal: Integer): TObject;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetAsStream(Ordinal: Integer): TObject;
begin
  Result := GetStream(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetStream(Ordinal: Integer; Value: TObject);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetByteArray(Ordinal: Integer): TBytes;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetAsByteArray(Ordinal: Integer): TBytes;
begin
  Result := GetByteArray(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetByteArray(Ordinal: Integer; Value: TBytes);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetObject(Ordinal: Integer): TObject;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.GetObject(Ordinal: Integer; DefaultValue: TObject): TObject;
begin
  if IsNull(Ordinal) then
    Result := DefaultValue
  else
    Result := GetObject(Ordinal);
end;

procedure TDBXDefaultRowStorage.SetObject(Ordinal: Integer; Value: TObject);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.IsNull(Ordinal: Integer): Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultRowStorage.SetNull(Ordinal: Integer);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.IsAssignedNull(Ordinal: Integer): Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultRowStorage.SetAssignedNull(Ordinal: Integer);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultRowStorage.IsUnassignedNull(Ordinal: Integer): Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultRowStorage.SetUnassignedNull(Ordinal: Integer);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.CopyFrom(const Source: TDBXTableStorage);
var
  ColumnCount: Integer;
  Ordinal: Integer;
begin
  ColumnCount := Length(Columns);
  while Source.Next do
  begin
    NewRow;
    for ordinal := 0 to ColumnCount - 1 do
      Source.CopyTo(Ordinal, self, Ordinal);
    InsertRow;
  end;
end;

procedure TDBXDefaultTableStorage.SetColumns(const Columns: TDBXColumnDescriptorArray);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.BeforeFirst;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.Next: Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.NewRow;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.InsertRow;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.Close;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.Clear;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.DeleteRow;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.GetStorage: TObject;
begin
  Result := nil;
end;

function TDBXDefaultTableStorage.GetCommand: TObject;
begin
  Result := nil;
end;

function TDBXDefaultTableStorage.FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.SetHiddenColumn(const ColumnName: WideString);
begin
  raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXDefaultTableStorage.AcceptChanges;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.GetDeletedRows: TDBXTableStorage;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.GetInsertedRows: TDBXTableStorage;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

function TDBXDefaultTableStorage.GetModifiedRows: TDBXTableStorage;
begin
  raise Exception.Create(SUnsupportedOperation);
end;

constructor TDBXDelegateTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create;
  self.FTable := Table;
end;

destructor TDBXDelegateTableStorage.Destroy;
begin
  FreeAndNil(FTable);
  inherited Destroy;
end;

function TDBXDelegateTableStorage.ReplaceStorage(Table: TDBXTableStorage): TDBXTableStorage;
var
  OldTable: TDBXTableStorage;
begin
  OldTable := self.FTable;
  self.FTable := Table;
  Result := OldTable;
end;

procedure TDBXDelegateTableStorage.BeforeFirst;
begin
  FTable.BeforeFirst;
end;

function TDBXDelegateTableStorage.Next: Boolean;
begin
  Result := FTable.Next;
end;

procedure TDBXDelegateTableStorage.NewRow;
begin
  FTable.NewRow;
end;

procedure TDBXDelegateTableStorage.InsertRow;
begin
  FTable.InsertRow;
end;

procedure TDBXDelegateTableStorage.CopyFrom(const Source: TDBXTableStorage);
begin
  FTable.CopyFrom(Source);
end;

procedure TDBXDelegateTableStorage.Close;
begin
  FTable.Close;
end;

procedure TDBXDelegateTableStorage.Clear;
begin
  FTable.Clear;
end;

procedure TDBXDelegateTableStorage.DeleteRow;
begin
  FTable.DeleteRow;
end;

function TDBXDelegateTableStorage.GetStorage: TObject;
begin
  Result := FTable.Storage;
end;

function TDBXDelegateTableStorage.GetCommand: TObject;
begin
  Result := FTable.Command;
end;

function TDBXDelegateTableStorage.FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean;
begin
  Result := FTable.FindStringKey(Ordinal, Value);
end;

procedure TDBXDelegateTableStorage.SetHiddenColumn(const ColumnName: WideString);
begin
  FTable.HiddenColumn := ColumnName;
end;

procedure TDBXDelegateTableStorage.AcceptChanges;
begin
  FTable.AcceptChanges;
end;

function TDBXDelegateTableStorage.GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage;
begin
  Result := FTable.GetCurrentRows(OrderByColumnName);
end;

function TDBXDelegateTableStorage.GetDeletedRows: TDBXTableStorage;
begin
  Result := FTable.DeletedRows;
end;

function TDBXDelegateTableStorage.GetInsertedRows: TDBXTableStorage;
begin
  Result := FTable.InsertedRows;
end;

function TDBXDelegateTableStorage.GetModifiedRows: TDBXTableStorage;
begin
  Result := FTable.ModifiedRows;
end;

function TDBXDelegateTableStorage.GetColumns: TDBXColumnDescriptorArray;
begin
  Result := FTable.Columns;
end;

procedure TDBXDelegateTableStorage.SetColumns(const Columns: TDBXColumnDescriptorArray);
begin
  FTable.Columns := Columns;
end;

function TDBXDelegateTableStorage.GetMetaDataCollectionName: WideString;
begin
  Result := FTable.MetaDataCollectionName;
end;

function TDBXDelegateTableStorage.GetMetaDataCollectionIndex: Integer;
begin
  Result := FTable.MetaDataCollectionIndex;
end;

function TDBXDelegateTableStorage.FindOrdinal(const ColumnName: WideString): Integer;
begin
  Result := FTable.FindOrdinal(ColumnName);
end;

function TDBXDelegateTableStorage.EqualTo(const Ordinal: Integer; const Target: TDBXRowStorage; const TargetOrdinal: Integer): Boolean;
begin
  Result := FTable.EqualTo(Ordinal, Target, TargetOrdinal);
end;

function TDBXDelegateTableStorage.GetOriginalRow: TDBXRowStorage;
begin
  Result := FTable.OriginalRow;
end;

function TDBXDelegateTableStorage.GetUnsignedByte(Ordinal: Integer): SmallInt;
begin
  Result := FTable.GetUnsignedByte(Ordinal);
end;

function TDBXDelegateTableStorage.GetUnsignedByte(Ordinal: Integer; DefaultValue: SmallInt): SmallInt;
begin
  Result := FTable.GetUnsignedByte(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsUnsignedByte(Ordinal: Integer): SmallInt;
begin
  Result := FTable.GetAsUnsignedByte(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetUnsignedByte(Ordinal: Integer; Value: SmallInt);
begin
  FTable.SetUnsignedByte(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetByte(Ordinal: Integer): Byte;
begin
  Result := FTable.GetByte(Ordinal);
end;

function TDBXDelegateTableStorage.GetByte(Ordinal: Integer; DefaultValue: Byte): Byte;
begin
  Result := FTable.GetByte(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsByte(Ordinal: Integer): Byte;
begin
  Result := FTable.GetAsByte(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetByte(Ordinal: Integer; Value: Byte);
begin
  FTable.SetByte(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := FTable.GetInt16(Ordinal);
end;

function TDBXDelegateTableStorage.GetInt16(Ordinal: Integer; DefaultValue: SmallInt): SmallInt;
begin
  Result := FTable.GetInt16(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsInt16(Ordinal: Integer): SmallInt;
begin
  Result := FTable.GetAsInt16(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetInt16(Ordinal: Integer; Value: SmallInt);
begin
  FTable.SetInt16(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := FTable.GetInt32(Ordinal);
end;

function TDBXDelegateTableStorage.GetInt32(Ordinal: Integer; DefaultValue: Integer): Integer;
begin
  Result := FTable.GetInt32(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsInt32(Ordinal: Integer): Integer;
begin
  Result := FTable.GetAsInt32(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetInt32(Ordinal: Integer; Value: Integer);
begin
  FTable.SetInt32(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := FTable.GetInt64(Ordinal);
end;

function TDBXDelegateTableStorage.GetInt64(Ordinal: Integer; DefaultValue: Int64): Int64;
begin
  Result := FTable.GetInt64(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsInt64(Ordinal: Integer): Int64;
begin
  Result := FTable.GetAsInt64(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetInt64(Ordinal: Integer; Value: Int64);
begin
  FTable.SetInt64(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := FTable.GetBoolean(Ordinal);
end;

function TDBXDelegateTableStorage.GetBoolean(Ordinal: Integer; DefaultValue: Boolean): Boolean;
begin
  Result := FTable.GetBoolean(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsBoolean(Ordinal: Integer): Boolean;
begin
  Result := FTable.GetAsBoolean(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetBoolean(Ordinal: Integer; Value: Boolean);
begin
  FTable.SetBoolean(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetFloat(Ordinal: Integer): Single;
begin
  Result := FTable.GetFloat(Ordinal);
end;

function TDBXDelegateTableStorage.GetFloat(Ordinal: Integer; DefaultValue: Single): Single;
begin
  Result := FTable.GetFloat(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsFloat(Ordinal: Integer): Single;
begin
  Result := FTable.GetAsFloat(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetFloat(Ordinal: Integer; Value: Single);
begin
  FTable.SetFloat(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetDouble(Ordinal: Integer): Double;
begin
  Result := FTable.GetDouble(Ordinal);
end;

function TDBXDelegateTableStorage.GetDouble(Ordinal: Integer; DefaultValue: Double): Double;
begin
  Result := FTable.GetDouble(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsDouble(Ordinal: Integer): Double;
begin
  Result := FTable.GetAsDouble(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetDouble(Ordinal: Integer; Value: Double);
begin
  FTable.SetDouble(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetString(Ordinal: Integer): WideString;
begin
  Result := FTable.GetString(Ordinal);
end;

function TDBXDelegateTableStorage.GetString(Ordinal: Integer; const DefaultValue: WideString): WideString;
begin
  Result := FTable.GetString(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsString(Ordinal: Integer): WideString;
begin
  Result := FTable.GetAsString(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetString(Ordinal: Integer; const Value: WideString);
begin
  FTable.SetString(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetDecimal(Ordinal: Integer): TObject;
begin
  Result := FTable.GetDecimal(Ordinal);
end;

function TDBXDelegateTableStorage.GetDecimal(Ordinal: Integer; DefaultValue: TObject): TObject;
begin
  Result := FTable.GetDecimal(Ordinal, DefaultValue);
end;

function TDBXDelegateTableStorage.GetAsDecimal(Ordinal: Integer): TObject;
begin
  Result := FTable.GetAsDecimal(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetDecimal(Ordinal: Integer; Value: TObject);
begin
  FTable.SetDecimal(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetTimestamp(Ordinal: Integer): TObject;
begin
  Result := FTable.GetTimestamp(Ordinal);
end;

function TDBXDelegateTableStorage.GetAsTimestamp(Ordinal: Integer): TObject;
begin
  Result := FTable.GetAsTimestamp(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetTimestamp(Ordinal: Integer; Value: TObject);
begin
  FTable.SetTimestamp(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetStream(Ordinal: Integer): TObject;
begin
  Result := FTable.GetStream(Ordinal);
end;

function TDBXDelegateTableStorage.GetAsStream(Ordinal: Integer): TObject;
begin
  Result := FTable.GetAsStream(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetStream(Ordinal: Integer; Value: TObject);
begin
  FTable.SetStream(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetByteArray(Ordinal: Integer): TBytes;
begin
  Result := FTable.GetByteArray(Ordinal);
end;

function TDBXDelegateTableStorage.GetAsByteArray(Ordinal: Integer): TBytes;
begin
  Result := FTable.GetAsByteArray(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetByteArray(Ordinal: Integer; Value: TBytes);
begin
  FTable.SetByteArray(Ordinal, Value);
end;

function TDBXDelegateTableStorage.GetObject(Ordinal: Integer): TObject;
begin
  Result := FTable.GetObject(Ordinal);
end;

function TDBXDelegateTableStorage.GetObject(Ordinal: Integer; DefaultValue: TObject): TObject;
begin
  Result := FTable.GetObject(Ordinal, DefaultValue);
end;

procedure TDBXDelegateTableStorage.SetObject(Ordinal: Integer; Value: TObject);
begin
  FTable.SetObject(Ordinal, Value);
end;

function TDBXDelegateTableStorage.IsNull(Ordinal: Integer): Boolean;
begin
  Result := FTable.IsNull(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetNull(Ordinal: Integer);
begin
  FTable.SetNull(Ordinal);
end;

function TDBXDelegateTableStorage.IsAssignedNull(Ordinal: Integer): Boolean;
begin
  Result := FTable.IsAssignedNull(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetAssignedNull(Ordinal: Integer);
begin
  FTable.AssignedNull := Ordinal;
end;

function TDBXDelegateTableStorage.IsUnassignedNull(Ordinal: Integer): Boolean;
begin
  Result := FTable.IsUnassignedNull(Ordinal);
end;

procedure TDBXDelegateTableStorage.SetUnassignedNull(Ordinal: Integer);
begin
  FTable.UnassignedNull := Ordinal;
end;

end.
