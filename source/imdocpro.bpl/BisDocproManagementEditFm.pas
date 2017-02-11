unit BisDocproManagementEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm;

type
  TBisDocproManagementEditForm = class(TBisDataEditForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDocproManagementEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproManagementEditForm: TBisDocproManagementEditForm;

implementation

{$R *.dfm}

{ TBisDocproManagementEditFormIface }

constructor TBisDocproManagementEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproManagementEditForm;
end;

end.
