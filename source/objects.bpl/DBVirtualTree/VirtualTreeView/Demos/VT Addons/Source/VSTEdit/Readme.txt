MF Editor components and a editor link component for VirtualStringTree
Version 1.0.2 Beta
Copyright (c) 2001 Manfred Fuchs



Description
-----------

1.  Add the needed MF Editors to your form and set Visible := False.

2.  Add one ore more TVSTEditor components to your form.

3.  Add the MF Editors in the property fields.

4.  Set the OnCreateEditor event of your VirtualStringTree.

5.  Fill OnCreateEditor() with code.
    Example:
        Data := Sender.GetNodeData( Node );
        with Data^. do
        begin
          case <what editor is needed> of
            <need string editor>:
              VSTEditor.LinkEditor(EditLink,<string value>);
            <need string editor with button>:
              VSTEditor.LinkButtonEditor(EditLink,<string value>);
            <need combo editor>:
              VSTEditor.LinkComboEditor(EditLink,<string value>);
            <need numeric editor>:
              VSTEditor.LinkNumEditor(EditLink,<numeric value>);
            <need datetime editor>:
              VSTEditor.LinkDateTimeEditor(EditLink,<date value>,<time value>);
          end;
        end;

6.  Set the OnNewText event of your VirtualStringTree.

7.  Fill OnNewText() with code. After editing the appropriate editor have
    the new data value.
    Example:
        Data := Sender.GetNodeData( Node );
        with Data^. do
        begin
          case <what editor is used> of
            <string editor>,
            <string editor with button>,
            <combo editor>:
              <string value> := Text;
            <numeric editor>:
              <numeric value> := VSTEditor.NumEditor.Value;
            <datetime editor>:
              <date value> := VSTEditor.DateTimeEditor.Date;
              or
              <time value> := VSTEditor.DateTimeEditor.Time;
          end;
        end;



-------------------------------------
------ Manfred Fuchs ends here ------
-------------------------------------

--------------------------------------------
------ Problem with interfaces in BCB ------
--------------------------------------------
This is a frequent question, so:

Question:
> I have the treeview and the addon package from yg.  I am trying to
> implement a combo editor.  I have followed the instructions that came with
> it.  I have implemented the OnCreateEditor function:
>
> void __fastcall TForm1::GroupUserTreeView1CreateEditor(
>       TBaseVirtualTree *Sender, PVirtualNode Node, int Column,
>       IVTEditLink *EditLink)
> {
>     if (Column == 1) {
>         TreeNodeData *tdata = (TreeNodeData *)Sender->GetNodeData(Node);
>         VSTEditor1->LinkEditor(EditLink, tdata->mName);
>     }
> }
>
> I get an access violation on the VSTEditor1->LinkEditor(EditLink,
> tdata->mName).


Answer:

There is a problem with the event's signature. It has to be

void __fastcall TForm1::GroupUserTreeView1CreateEditor(
      TBaseVirtualTree *Sender, PVirtualNode Node, int Column,
      _di_IVTEditLink &EditLink)

(The last parameter is different). You can
1. Correct the declaration, and then assign the event in FormCreate (the
designer would complain if you try to assign the modified event in designtime), or
2. cast the *EditLink to the right type, as follows:

  _di_IVTEditLink *RealEditLink=(_di_IVTEditLink *)EditLink;
  ...
  VSTEditor1->LinkEditor(*RealEditLink, tdata->mName);


My test project works fine with both solutions. If you have problems in more
complicated situations, contact me at milan_va@seznam.cz .
