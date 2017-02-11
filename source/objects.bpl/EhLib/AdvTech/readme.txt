This directory contain components and utilities which on various reasons
does not include in EhLib package.
Using these components and utilities take into account that in the 
next versions of the library its can be powerfully changed, moved to 
EhLib package or removed from the library at all.


This version of EhLib includes next components and utilities:

1. EhLibCLX
  EhLibCLX directory contain preview restricted version of EhLibCLX -
  EhLib under Borland Component Library for Cross-Platform.
  In current time fully converted next units:
    DBSumList, PropFilerEh, PropStorageEh, PropStorageEditEh.

2. CDSDesign
  CDSDesign directory contain design-time ClientDataSet edit window,
  It inherited from TFieldsEditor window, include all features of 
  FieldsEditor and allow to edit data in ClientDataSet at 
  design-time. You can manually fill data at design-time in 
  disconnected ClientDataSet without loading data from file or
  copying from another dataset.

3. MemTableEh directory contains preview version of the TMemTableEh 
   component and data provider - TDataDriverEh.
   TMemTableEh - dataset, which hold all data in memory. You can consider it 
   as an array of records.
   TDataDriverEh - carry out two tasks:
     1. Delivers data to TMemTableEh.
     2. Processes changed records of TMemTableEh (For instance, translates 
        changes to SQL expressions and sends them to the server).

