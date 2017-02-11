unit DialectConfigurationSection;

interface
uses
  System.Configuration,
  System.Reflection;

type
  TMetaDataDialectElement = class sealed(ConfigurationElement)
  private
    const ProductNameKey = 'ProductName';
    const ConnectionTypeKey = 'ConnectionType';
    const DialectTypeKey = 'DialectType';
  private
    function GetProductName: WideString;
    procedure SetProductName(Value: WideString);
    function GetConnectionType: WideString;
    procedure SetConnectionType(Value: WideString);
    function GetDialectType: WideString;
    procedure SetDialectType(Value: WideString);
  public
    [ConfigurationProperty(ProductNameKey, IsRequired=true)]
    property ProductName: WideString read GetProductName write SetProductName;
    [ConfigurationProperty(ConnectionTypeKey, IsRequired = false)]
    property ConnectionType: WideString read GetConnectionType write SetConnectionType;
    [ConfigurationProperty(DialectTypeKey, IsRequired = true)]
    property DialectType: WideString read GetDialectType write SetDialectType;
  end;

  TMetaDataDialectCollection = class sealed(ConfigurationElementCollection)
  private
    const MetaDataDialectKey = 'Dialect';
  strict protected
    function CreateNewElement: ConfigurationElement; override;
    function GetElementKey(Element: ConfigurationElement): TObject; override;
    function get_ElementName: WideString; override;
  private
    function GetItem(Index: Integer): TMetaDataDialectElement;
    procedure SetItem(Index: Integer; Element: TMetaDataDialectElement);
  public
    function get_CollectionType: ConfigurationElementCollectionType; override;
    class function ProduceKey(ProductName: WideString; ConnectionType: WideString): WideString; static;
    property Item[Index: Integer]: TMetaDataDialectElement read GetItem write SetItem; default;
  end;

  TDialectConfigurationSection = class(ConfigurationSection)
  public
    const SectionName = 'DialectConfigurationSection';
    const MetaDataDialectsKey = 'MetaDataDialects';
  private
    function GetMetaDataDialects: TMetaDataDialectCollection;
    procedure SetMetaDataDialects(Collection: TMetaDataDialectCollection);
  public
    [ConfigurationProperty(MetaDataDialectsKey, IsDefaultCollection = true)]
    property MetaDataDialects: TMetaDataDialectCollection read GetMetaDataDialects write SetMetaDataDialects;
  end;

implementation

function TMetaDataDialectElement.GetProductName: WideString;
begin
  Result := WideString(Item[ProductNameKey]);
end;

procedure TMetaDataDialectElement.SetProductName(Value: WideString);
begin
  Item[ProductNameKey] := Value;
end;

function TMetaDataDialectElement.GetConnectionType: WideString;
begin
  Result := WideString(Item[ConnectionTypeKey]);
end;

procedure TMetaDataDialectElement.SetConnectionType(Value: WideString);
begin
  Item[ConnectionTypeKey] := Value;
end;

function TMetaDataDialectElement.GetDialectType: WideString;
begin
  Result := WideString(Item[DialectTypeKey]);
end;

procedure TMetaDataDialectElement.SetDialectType(Value: WideString);
begin
  Item[DialectTypeKey] := Value;
end;

class function TMetaDataDialectCollection.ProduceKey(ProductName: WideString; ConnectionType: WideString): WideString;
var
  Key: WideString;
begin
  Key := ProductName.ToLower();
  if (ConnectionType <> nil) and (ConnectionType.Length > 0) then
    Key := Key + '#' + ConnectionType;
  Result := Key;
end;

function TMetaDataDialectCollection.CreateNewElement: ConfigurationElement;
begin
  Result := TMetaDataDialectElement.Create;
end;

function TMetaDataDialectCollection.GetElementKey(Element: ConfigurationElement): TObject;
var
  MetaElement: TMetaDataDialectElement;
begin
  MetaElement := TMetaDataDialectElement(Element);
  Result := ProduceKey(MetaElement.ProductName, MetaElement.ConnectionType);
end;

function TMetaDataDialectCollection.get_CollectionType: ConfigurationElementCollectionType;
begin
  Result := ConfigurationElementCollectionType.BasicMap;
end;

function TMetaDataDialectCollection.get_ElementName: WideString;
begin
  Result := MetaDataDialectKey;
end;

function TMetaDataDialectCollection.GetItem(Index: Integer): TMetaDataDialectElement;
begin
  Result := TMetaDataDialectElement(BaseGet(Index));
end;

procedure TMetaDataDialectCollection.SetItem(Index: Integer; Element: TMetaDataDialectElement);
begin
  if BaseGet(Index) <> nil then
    BaseRemoveAt(Index);
  BaseAdd(Index, Element);
end;

function TDialectConfigurationSection.GetMetaDataDialects: TMetaDataDialectCollection;
begin
  Result := TMetaDataDialectCollection(Item[MetaDataDialectsKey]);
end;

procedure TDialectConfigurationSection.SetMetaDataDialects(Collection: TMetaDataDialectCollection);
begin
  Item[MetaDataDialectsKey] := Collection;
end;

end.

