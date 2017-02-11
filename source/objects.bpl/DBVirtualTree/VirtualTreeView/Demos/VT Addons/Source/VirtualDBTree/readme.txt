I do not use VirtualDBTree myself, but this may be better than nothing.
-----------------------------------------------------------------------

zai_xiong replied to one of the confused:

Well, you can point these 3 components to a same datasource which 
will give what you want.

I guess help file is not necessary. Here is some guide lines:-

1.  Assign a datasource to VirtualDBTreeEx
2.  Assign the minimum 3 field names of fields in your database 
    pointed to by the datasource to property KeyFieldName,
    ParentFieldName and ViewFieldName, respectively.
3.  Open you dataset. You should be able to see the tree populated
    by the records in your dataset. Note that you need to have 
    Parent-Child relationship setup properly in your dataset in order
    to see the results. In my own database, I used these fields:-
          ID, ParentID, NType
4.  If you would like to see Icons in the tree, assign a ImageList to
    the tree, then assign a field name to property ImgIdxFieldName.
