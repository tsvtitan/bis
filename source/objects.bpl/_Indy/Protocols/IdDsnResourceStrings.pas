{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13806: IdDsnResourceStrings.pas 
{
{   Rev 1.0    11/14/2002 02:19:02 PM  JPMugaas
}
unit IdDsnResourceStrings;
{This is only for resource strings that appear in the design-time editors in the main Indy package}
interface
resourcestring
  {Binding Editor stuff}
  {
  Note to translators - Please Read!!!

  & symbol before a letter or number.  This is rendered as that chractor being
  underlined.  In addition, the charactor after the & symbol along with the ALT
  key enables a user to move to that control.  Since these are on one form, be
  careful to ensure that the same letter or number does not have a & before it
  in more than one string, otherwise an ALT key sequence will be broken.

  }
  {Design time SASLList Hints}
  RSADlgSLMoveUp = 'Move Up';
  RSADlgSLMoveDown = 'Move Down';
  RSADlgSLAdd = 'Add';
  RSADlgSLRemove = 'Remove';
  //Caption that uses format with component name
  RSADlgSLCaption = 'Editing SASL List for %s';
  RSADlgSLAvailable = '&Available';
  RSADlgSLAssigned = 'A&ssigned (tried in order listed)';
  {Note that the Ampersand indicates an ALT keyboard sequence}
  RSADlgSLEditList = 'Edit &List';

implementation

end.
