unit BisDesignDataSessionsFm;

interface

uses                                                                                             
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,
  VirtualTrees, 
  BisFm, BisDataGridFm, BisDataEditFm, BisDBTree, BisDataFrm;

type
  TBisDesignDataSessionsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoQueryText: TDBMemo;
  private
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataSessionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataSessionViewFormIface=class(TBisDataEditFormIface)
  public
    procedure Execute; override;
  end;

  TBisDesignDataSessionDeleteFormIface=class(TBisDataEditFormIface)
  private
    FSDeleteCurrentSession: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute; override;
  published
    property SDeleteCurrentSession: String read FSDeleteCurrentSession write FSDeleteCurrentSession;
  end;

var
  BiDesignDataSessionsForm: TBisDesignDataSessionsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisProvider, BisDialogs, BisParam, BisMemoFm, BisFilterGroups,
     BisOrders, BisCore, BisUtils,
     BisDesignDataSessionsFrm;

{ TBisDesignDataSessionDeleteFormIface }

constructor TBisDesignDataSessionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSDeleteCurrentSession:='������� ������� ������?';
end;

procedure TBisDesignDataSessionDeleteFormIface.Execute;
var
  Provider: TBisProvider;
begin
  if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
    if ShowQuestion(FSDeleteCurrentSession,mbNo)=mrYes then begin
      Provider:=TBisProvider.Create(Self);
      try
        Provider.ProviderName:='D_SESSION';
        Provider.ParentDataSet:=ParentDataSet;
        Provider.Params.AddKeyValue('SESSION_ID',ParentDataSet.FieldByName('SESSION_ID').Value).Older('OLD_SESSION_ID');
        Provider.Execute;
        Provider.DeleteFromParent;
      finally
        Provider.Free;
      end;
    end;
  end;
end;

{ TBisDesignDataSessionViewFormIface }

procedure TBisDesignDataSessionViewFormIface.Execute;
var
  Form: TBisMemoForm;
begin
  if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
    Form:=TBisMemoForm.Create(Self);
    try
      Form.Memo.Lines.Text:=ParentDataSet.FieldByName('PARAMS').AsString;
      Form.ButtonOk.Visible:=false;
      Form.Caption:='���������';
      Form.ShowModal;
    finally
      Form.Free;
    end;
  end;
end;

{ TBisDesignDataSessionsFormIface }

constructor TBisDesignDataSessionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataSessionsForm;
  ViewClass:=TBisDesignDataSessionViewFormIface;
  DeleteClass:=TBisDesignDataSessionDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_SESSIONS';
  with FieldNames do begin
    AddKey('SESSION_ID');
    AddInvisible('APPLICATION_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('PARAMS');
    AddInvisible('QUERY_TEXT');
    Add('APPLICATION_NAME','����������',100);
    Add('USER_NAME','������� ������',100);
    Add('DATE_CREATE','���� ��������',120);
    Add('DATE_CHANGE','���� ���������',120);
    Add('DURATION','������',50);
  end;
  Orders.Add('DATE_CREATE');
  Orders.Add('DATE_CHANGE');
end;

{ TBisDesignDataSessionsForm }

constructor TBisDesignDataSessionsForm.Create(AOwner: TComponent);
{var
  D: TDateTime;   }
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin

    with DataFrame do begin
      Provider.UseCache:=false; 
      ActionInsert.Visible:=false;
      ActionDuplicate.Visible:=false;
      ActionUpdate.Visible:=false;
      Grid.OnPaintText:=GridPaintText;
    end;

  {  D:=Core.ServerDate;

    with DataFrame.CreateFilterMenuItem('�������') do begin
      with FilterGroups.AddVisible do begin
        Filters.Add('DATE_CHANGE',fcEqualGreater,DateOf(D));
        Filters.Add('DATE_CHANGE',fcLess,IncDay(DateOf(D)));
      end;
      Checked:=true;
    end;

    with DataFrame.CreateFilterMenuItem('�����') do begin
      FilterGroups.AddVisible.Filters.Add('DATE_CREATE',fcLess,DateOf(D));
    end;  }

    DBMemoQueryText.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisDesignDataSessionsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataSessionsFrame;
end;

procedure TBisDesignDataSessionsForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                   Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PBisDBTreeNodeData;
begin
  Data:=DataFrame.Grid.GetNodeData(Node);
  if Assigned(Data) then begin
    if (Length(Data.KeyValues)>0) and
       VarSameValueEx(Data.KeyValues[Low(Data.KeyValues)],Core.SessionId) and
       ((Node=DataFrame.Grid.FocusedNode) and (Column<>DataFrame.Grid.FocusedColumn) or (Node<>DataFrame.Grid.FocusedNode)) then
      TargetCanvas.Font.Color:=clRed;
  end;
end;

end.
