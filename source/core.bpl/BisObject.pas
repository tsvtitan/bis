unit BisObject;

interface

uses Classes,
     BisObjectIntf;

type
  TBisObject=class(TComponent,IBisObject)
  private
    FObjectName: String;
    FDescription: String;
    FCaption: String;
    function GetParentObject: TBisObject;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateInited(AOwner: TComponent; Dummy: Integer=0); virtual;
    procedure Init; virtual;
    procedure Done; virtual;
    class function GetObjectName: String; virtual;

    property ParentObject: TBisObject read GetParentObject;
  published
    property ObjectName: String read FObjectName write FObjectName;
    property Caption: String read FCaption write FCaption;
    property Description: String read FDescription write FDescription;
  end;

  TBisObjectClass=class of TBisObject;

implementation

uses SysUtils;

{ TBisObject }

constructor TBisObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjectName:=GetObjectName;
end;

constructor TBisObject.CreateInited(AOwner: TComponent; Dummy: Integer=0);
begin
  Create(AOwner);
  Init;
end;

procedure TBisObject.Init;
begin
end;

procedure TBisObject.Done;
begin
end;

class function TBisObject.GetObjectName: String;
begin
  Result:=Copy(ClassName,Length('TBis')+1,Length(ClassName));
end;

function TBisObject.GetParentObject: TBisObject;
begin
  Result:=nil;
  if Assigned(Owner) and (Owner is TBisObject) then begin
    Result:=TBisObject(Owner);
  end;
end;

end.