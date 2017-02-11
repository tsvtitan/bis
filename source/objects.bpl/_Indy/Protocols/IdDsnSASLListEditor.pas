{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13808: IdDsnSASLListEditor.pas 
{
{   Rev 1.6    9/5/2004 3:16:58 PM  JPMugaas
{ Should work in D9 DotNET.
}
{
{   Rev 1.5    3/8/2004 10:14:56 AM  JPMugaas
{ Property editor for SASL mechanisms now supports TIdDICT.
}
{
{   Rev 1.4    2/26/2004 8:53:16 AM  JPMugaas
{ Hack to restore the property editor for SASL mechanisms.
}
{
{   Rev 1.3    1/25/2004 3:11:08 PM  JPMugaas
{ SASL Interface reworked to make it easier for developers to use.
{ SSL and SASL reenabled components.
}
{
{   Rev 1.2    10/12/2003 1:49:30 PM  BGooijen
{ Changed comment of last checkin
}
{
{   Rev 1.1    10/12/2003 1:43:30 PM  BGooijen
{ Changed IdCompilerDefines.inc to Core\IdCompilerDefines.inc
}
{
{   Rev 1.0    11/14/2002 02:19:08 PM  JPMugaas
}
unit IdDsnSASLListEditor;

interface

{$I IdCompilerDefines.inc}

uses
  Classes,
  {$IFDEF VCL9ORABOVE}
     {$IFDEF DOTNET}
      Borland.Vcl.Design.DesignIntF,
      Borland.Vcl.Design.DesignEditors;
     {$ELSE}
      DesignIntf, 
      DesignEditors;
     {$ENDIF}
  {$ELSE}
    {$IFDEF VCL6ORABOVE}
      DesignIntf, 
      DesignEditors;
    {$ELSE}
       Dsgnintf;
    {$ENDIF}
  {$ENDIF}

type
  TIdPropEdSASL = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

implementation
uses
  SysUtils,
  IdDICT,
  IdDsnResourceStrings, IdDsnSASLListEditorForm,
  IdIMAP4,
  IdPOP3,
  IdSASL,
  IdSASLCollection,
  IdSMTP,
  {$IFDEF LINUX}
  QControls
  {$ELSE}
  Controls
  {$ENDIF};


{ TIdPropEdSASL }

procedure TIdPropEdSASL.Edit;
var LF : TfrmSASLListEditor;
begin
  inherited;
  LF := TfrmSASLListEditor.Create(nil);
  try
    if PropCount > 0 then
    begin

      if GetComponent(0) is TComponent then
      begin
        LF.SetComponentName(TComponent(GetComponent(0)).Name);
      end;
//      LF.SetComponentName(GetComponent(0).Name );
      if GetComponent(0) is TIdSMTP then
      begin
        LF.SetList(TIdSMTP(GetComponent(0)).SASLMechanisms);
        if LF.ShowModal=mrOk then
        begin
          LF.GetList(TIdSMTP(GetComponent(0)).SASLMechanisms);
        end;
      end;
      if GetComponent(0) is TIdIMAP4 then
      begin
        LF.SetList(TIdIMAP4(GetComponent(0)).SASLMechanisms);
        if LF.ShowModal=mrOk then
        begin
          LF.GetList(TIdIMAP4(GetComponent(0)).SASLMechanisms);
        end;
      end;
      if GetComponent(0) is TIdPOP3 then
      begin
        LF.SetList(TIdPOP3(GetComponent(0)).SASLMechanisms);
        if LF.ShowModal=mrOk then
        begin
          LF.GetList(TIdPOP3(GetComponent(0)).SASLMechanisms);
        end;
      end;
      if GetComponent(0) is TIdDICT then
      begin
        LF.SetList(TIdDICT(GetComponent(0)).SASLMechanisms);
        if LF.ShowModal=mrOk then
        begin
          LF.GetList(TIdDICT(GetComponent(0)).SASLMechanisms);
        end;
      end;
    end;
  finally
    FreeAndNil(LF);
  end;
end;

function TIdPropEdSASL.GetAttributes: TPropertyAttributes;
begin
  result := [paDialog];
end;

function TIdPropEdSASL.GetValue: string;
begin
  Result := '';
end;

procedure TIdPropEdSASL.SetValue(const Value: string);
begin
  inherited;
end;

end.
