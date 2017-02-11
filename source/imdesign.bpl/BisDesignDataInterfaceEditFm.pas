unit BisDesignDataInterfaceEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                     
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisInterfaces, BisParam, BisControls;

type

  TBisDesignDataInterfaceEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxRefresh: TCheckBox;
    LabelModuleName: TLabel;
    ComboBoxModuleName: TComboBox;
    LabelModuleInterface: TLabel;
    ComboBoxModuleInterface: TComboBox;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
  end;

  TBisDesignDataInterfaceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataInterfaceInsertFormIface=class(TBisDesignDataInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataInterfaceUpdateFormIface=class(TBisDesignDataInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataInterfaceDeleteFormIface=class(TBisDesignDataInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataInterfaceEditForm: TBisDesignDataInterfaceEditForm;

implementation

{$R *.dfm}

uses TypInfo,
     BisCore, BisIfaceModules, BisIfaces, BisUtils, BisDialogs, BisConsts;

{ TBisDesignDataInterfaceEditFormIface }

constructor TBisDesignDataInterfaceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataInterfaceEditForm;
  with Params do begin
    AddKey('INTERFACE_ID').Older('OLD_INTERFACE_ID');
    AddInvisible('INTERFACE_TYPE').Value:=Integer(itInternal);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBoxTextIndex('MODULE_NAME','ComboBoxModuleName','LabelModuleName',true);
    AddComboBoxTextIndex('MODULE_INTERFACE','ComboBoxModuleInterface','LabelModuleInterface',true);
  end;
end;

{ TBisDesignDataInterfaceInsertFormIface }

constructor TBisDesignDataInterfaceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_INTERFACE';
  Caption:='Создать внутренний интерфейс';
end;

{ TBisDesignDataInterfaceUpdateFormIface }

constructor TBisDesignDataInterfaceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_INTERFACE';
  Caption:='Изменить внутренний интерфейс';
end;

{ TBisDesignDataInterfaceDeleteFormIface }

constructor TBisDesignDataInterfaceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_INTERFACE';
  Caption:='Удалить внутренний интерфейс';
end;

{ TBisDesignDataInterfaceEditForm }

constructor TBisDesignDataInterfaceEditForm.Create(AOwner: TComponent);
var
  i: Integer;
  Module: TBisIfaceModule;
begin
  inherited Create(AOwner);

  ComboBoxModuleName.Clear;
  for i:=0 to Core.IfaceModules.Count-1 do begin
    Module:=Core.IfaceModules.Items[i];
    if Module.Enabled then
      ComboBoxModuleName.Items.AddObject(Module.ObjectName,Module);
  end;

end;

procedure TBisDesignDataInterfaceEditForm.ChangeParam(Param: TBisParam);
var
  i: Integer;
  Module: TBisIfaceModule;
//  Iface: TBisIface;
  AClass: TBisIfaceClass;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'MODULE_NAME') then begin
    if ComboBoxModuleName.ItemIndex<>-1 then begin
      ComboBoxModuleInterface.Clear;
      Module:=TBisIfaceModule(ComboBoxModuleName.Items.Objects[ComboBoxModuleName.ItemIndex]);
      if Assigned(Module) then begin
        for i:=0 to Module.Classes.Count-1 do begin
          AClass:=Module.Classes.Items[i];
{          Iface:=AClass.Create(nil);
          try
            Iface.Init;
            if Iface.Available then}
              ComboBoxModuleInterface.Items.AddObject(AClass.GetObjectName,TObject(AClass));
{          finally
            Iface.Free;
          end;}
        end;
{        for i:=0 to Module.Ifaces.Count-1 do begin
          Iface:=Module.Ifaces.Items[i];
          if Iface.Available then
            ComboBoxModuleInterface.Items.AddObject(Iface.ObjectName,Iface);
        end;}
      end;
    end else
      ComboBoxModuleInterface.Clear;
  end;

end;

procedure TBisDesignDataInterfaceEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then begin
    Core.RefreshPermissions;
    Core.ReloadInterfaces;
  end;
end;

end.
