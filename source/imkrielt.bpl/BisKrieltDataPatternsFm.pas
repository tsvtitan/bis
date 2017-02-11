unit BisKrieltDataPatternsFm;

interface
                                                                                                  
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisDataEditFm;

type
  TBisKrieltDataPatternsFrame=class(TBisDataGridFrame)
  private
    FExportId: Variant;
    FExportName: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;

    property ExportId: Variant read FExportId write FExportId;
    property ExportName: String read FExportName write FExportName; 
  end;

  TBisKrieltDataPatternsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisKrieltDataPatternsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPatternsForm: TBisKrieltDataPatternsForm;

implementation

uses BisUtils, BisKrieltDataPatternEditFm, BisConsts, BisParam;

{$R *.dfm}

{ TBisKrieltDataPatternsFrame }

constructor TBisKrieltDataPatternsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InsertClass:=TBisKrieltDataPatternInsertFormIface;
  UpdateClass:=TBisKrieltDataPatternUpdateFormIface;
  DeleteClass:=TBisKrieltDataPatternDeleteFormIface;
  with Provider do begin
    ProviderName:='S_PATTERNS';
    with FieldNames do begin
      AddKey('EXPORT_ID');
      AddKey('DESIGN_ID');
      AddInvisible('RTF');
      Add('DESIGN_NAME','����������',250);
      Add('EXPORT_NAME','�������',150);
    end;
  end;

  FExportId:=Null;
end;

procedure TBisKrieltDataPatternsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('EXPORT_NAME').Value:=FExportName;
      Param:=ParamByName('EXPORT_ID');
      Param.Value:=FExportId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataPatternsFormIface }

constructor TBisKrieltDataPatternsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPatternsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisKrieltDataPatternsForm }

class function TBisKrieltDataPatternsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataPatternsFrame;
end;

end.
