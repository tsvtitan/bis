unit BisDBTableViewFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, DBGrids, Grids,
  BisDataSet, BisDialogFm, BisControls;

type
  TBisDBTableViewForm = class(TBisDialogForm)
    PanelGrid: TPanel;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure PanelButtonClick(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FDataSet: TBisDataSet;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DataSet: TBisDataSet read FDataSet;
  end;

var
  BisDBTableViewForm: TBisDBTableViewForm;

implementation

uses TypInfo, Consts, kbmMemTable,
     BisConsts, BisUtils;

{$R *.dfm}

{ TBisDBTableEditForm }

constructor TBisDBTableViewForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet:=TBisDataSet.Create(nil);
  DataSource.DataSet:=FDataSet;
end;

procedure TBisDBTableViewForm.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBrush: TBrush;
  AGrid: TDbGrid;
begin
  AGrid:=TDbGrid(Sender);
  if not (gdFocused in State) and (gdSelected in State) then begin
    OldBrush:=TBrush.Create;
    OldBrush.Assign(AGrid.Canvas.Brush);
    try
      AGrid.Canvas.Brush.Color:=clGray;
      AGrid.Canvas.FillRect(Rect);
      AGrid.Canvas.Font.Color:=clHighlightText;
      AGrid.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
    finally
      AGrid.Canvas.Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end else
    AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

destructor TBisDBTableViewForm.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisDBTableViewForm.PanelButtonClick(Sender: TObject);
var
  i: Integer;
  NCount: Integer;
  S: String;
begin
  if FDataSet.Active then begin
    FDataSet.DisableControls;
    try
      S:='1000';
      if InputQuery('','',S) then begin
        if TryStrToInt(S,NCount) then begin
          for i:=0 to NCount-1 do begin
            FDataSet.Append;
            FDataSet.Fields[0].AsString:=GetUniqueID;
            FDataSet.Post;
          end;
        end;
      end;
    finally
      FDataSet.EnableControls;
    end;
  end;
end;

procedure TBisDBTableViewForm.ButtonLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    FDataSet.LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TBisDBTableViewForm.ButtonSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    if FDataSet.State in [dsEdit, dsInsert] then
      FDataSet.Post;
    FDataSet.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisDBTableViewForm.ButtonClearClick(Sender: TObject);
begin
  FDataSet.EmptyTable;
end;

end.
