unit BisDesignDataMenusFm;

interface
                                                                                                            
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataTreeFm, StdCtrls, ExtCtrls, ComCtrls, BisDataGridFm, ActnList;

type
  TBisDesignDataMenusForm = class(TBisDataTreeForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataMenusFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataMenusForm: TBisDesignDataMenusForm;

implementation

uses BisDesignDataMenuEditFm;

{$R *.dfm}

{ TBisDesignDataMenusFormIface }

constructor TBisDesignDataMenusFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataMenusForm;
  FilterClass:=TBisDesignDataMenuEditFormIface;
  InsertClasses.Add(TBisDesignDataMenuInsertFormIface);
  InsertClasses.Add(TBisDesignDataMenuInsertChildFormIface);
  UpdateClass:=TBisDesignDataMenuUpdateFormIface;
  DeleteClass:=TBisDesignDataMenuDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_MENUS';
  with FieldNames do begin
    AddKey('MENU_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('INTERFACE_ID');
    AddInvisible('INTERFACE_NAME');
    AddInvisible('DESCRIPTION');
    AddInvisible('SHORTCUT');
    Add('NAME','Наименование',225);
    Add('PARENT_NAME','Родитель',175);
    Add('PRIORITY','Порядок',50);
  end;
end;

end.
