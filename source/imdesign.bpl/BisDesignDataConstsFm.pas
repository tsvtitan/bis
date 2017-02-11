unit BisDesignDataConstsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls,
  BisDataGridFm, BisControls;
                                                                                                              
type
  TBisDesignDataConstsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxValue: TGroupBox;
    PanelDescription: TPanel;
    DBMemoValue: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataConstsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataConstsForm: TBisDesignDataConstsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataConstEditFm;

{ TBisDesignDataConstsFormIface }

constructor TBisDesignDataConstsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataConstsForm;
  FilterClass:=TBisDesignDataConstEditFormIface;
  InsertClass:=TBisDesignDataConstInsertFormIface;
  UpdateClass:=TBisDesignDataConstUpdateFormIface;
  DeleteClass:=TBisDesignDataConstDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_CONSTS';
  with FieldNames do begin
    AddInvisible('VALUE');
    Add('NAME','������������',200).IsKey:=true;
    Add('DESCRIPTION','��������',300);
    AddCheckBox('ENABLED','��������',40);
  end;
  Orders.Add('DESCRIPTION');
end;

{ TBisDesignDataConstsForm }

constructor TBisDesignDataConstsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  DBMemoValue.DataSource:=DataFrame.DataSource;
end;

end.
