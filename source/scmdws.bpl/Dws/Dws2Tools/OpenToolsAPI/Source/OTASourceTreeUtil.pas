{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 28, 2003                                                  }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{    Portions created by Mark Ericksen Copyright (C) 2002, 2003        }
{    Mark Ericksen, United States of America.                          }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s):                                                   }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

{ Utility functions designed to improve the use of the TSourceParseTree object
  with the Open Tools API. }
unit OTASourceTreeUtil;

interface

uses SysUtils, Classes, ToolsApi, Dialogs{Debug}, 
  {$IFDEF DELPHI6up}
  Types,     // Delphi 6+
  {$ELSE}
  Windows,   // Delphi 5
  {$ENDIF}
  SourceParserTree;

procedure ParseUnit(const Editor: IOTASourceEditor; Parser: TSourceParserTree);

procedure SelectNode(const Editor: IOTASourceEditor; const View: IOTAEditView; Node: TCodeTreeNode);
function ReturnSelection(const Editor: IOTASourceEditor; const View: IOTAEditView): string;
procedure ReplaceSelection(const Editor: IOTASourceEditor; const View: IOTAEditView;
  const NewText: string; Undoable: Boolean=True);
procedure CursorToBlockStart(const View: IOTAEditView; BlockStart: TOTACharPos);

implementation

{-----------------------------------------------------------------------------
  Procedure: ParseUnit
  Author:    Mark Ericksen
  Date:      08-Nov-2002
  Arguments: const Editor: IOTASourceEditor; Parser: TSourceParseTree
  Result:    None
  Purpose:   Parse the associated unit.
-----------------------------------------------------------------------------}
procedure ParseUnit(const Editor: IOTASourceEditor; Parser: TSourceParserTree);
const
  MaxBufRead = 32760;
var
  Stream: TMemoryStream;
  Reader: IOTAEditReader;
  StartFrom: Integer;
  ReadCount: Integer;
  ReadBuffer: array[0..MaxBufRead] of Char;
begin
  if not Assigned(Parser) then
    Exit;

  Parser.CodeNodeMap.Clear;

  Stream := TMemoryStream.Create;
  try
    // Pull the entire unit's code
    Reader := Editor.CreateReader;
    if not Assigned(Reader) then
      Exit;

    StartFrom := 0;
    try
      repeat
        ReadCount := Reader.GetText(StartFrom, @ReadBuffer[0], SizeOf(ReadBuffer));

        // add line terminator
        if (ReadCount > 0) and (ReadCount < SizeOf(ReadBuffer)) then
          ReadBuffer[ReadCount] := #0;
        Stream.Write(ReadBuffer, ReadCount);      // write buffer to stream
        //ShowMessage('Read:'+#13#10+ReadBuffer);   // show after terminiated for accurate view
        StartFrom := StartFrom + ReadCount;
      until ReadCount < SizeOf(ReadBuffer);
    finally
      Reader := nil;   // done with the reader.
    end;

    { Parse the stream }
    Parser.Run('', Stream);
    //ShowMessage('Total Nodes: '+IntToStr(Parser.CodeNodeMap.TotalCount));
  finally
    Stream.Free;
  end;
end;

procedure SelectNode(const Editor: IOTASourceEditor; const View: IOTAEditView; Node: TCodeTreeNode);
var
  BlockStart: TOTACharPos;
  BlockAfter: TOTACharPos;
begin
  { Get the block region in terms of the editor. }
  BlockStart.CharIndex := Node.StartPosXY.X;
  BlockStart.Line      := Node.StartPosXY.Y;
  BlockAfter.CharIndex := Node.EndPosXY.X;
  BlockAfter.Line      := Node.EndPosXY.Y;

  Editor.BlockStart    := BlockStart;
  Editor.BlockAfter    := BlockAfter;
  Editor.BlockVisible  := True;
end;

function ReturnSelection(const Editor: IOTASourceEditor; const View: IOTAEditView): string;
var
  StartPos, EndPos: LongInt;
  Reader: IOTAEditReader;
begin
  StartPos := View.CharPosToPos(Editor.BlockStart);
  EndPos   := View.CharPosToPos(Editor.BlockAfter);

  { Get the selected text. }
  Reader := Editor.CreateReader;
  SetLength(Result, EndPos - StartPos - 1);
  Reader.GetText(StartPos, PChar(Result), Length(Result));
  Reader := nil;
end;

procedure ReplaceSelection(const Editor: IOTASourceEditor; const View: IOTAEditView;
  const NewText: string; Undoable: Boolean);
var
  Writer: IOTAEditWriter;
begin
  // Get the right kind of writer.
  if Undoable then
    Writer := Editor.CreateUndoableWriter
  else
    Writer := Editor.CreateWriter;
  // Replace the selection with the specified text.
  Writer.CopyTo(View.CharPosToPos(Editor.BlockStart));
  Writer.DeleteTo(View.CharPosToPos(Editor.BlockAfter));
  Writer.Insert(PChar(NewText));
  Writer := nil;
end;

procedure CursorToBlockStart(const View: IOTAEditView; BlockStart: TOTACharPos);
var
  CursorPos: TOTAEditPos;
begin
  // Set the cursor to the start of the sorted text.
  View.ConvertPos(False, CursorPos, BlockStart);
  View.CursorPos := CursorPos;
end;

end.
