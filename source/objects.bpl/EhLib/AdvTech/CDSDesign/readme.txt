ClientDataSet design-time editor.

Tested under Delphi 6 and 7.

I. Description.

CDSDesign directory contain design-time ClientDataSet edit window,
It inherited from TFieldsEditor window, include all features of 
FieldsEditor and allow to edit data in ClientDataSet at 
design-time. You can manually fill data at design-time in 
disconnected ClientDataSet without loading data from file or
copying from another dataset.

See screenshots in CDSDesign.gif


II. Installation.

Copy dfm and pas files from this directory to the directory from which 
you install EhLib.
In Delphi IDE open package DclEhLibXX.Dpk and add new Pas files.
Under Delphi 6 need also add <DelphiPath>\Lib\dclmid.dcp package in 
'Requires' part of of EhLib package.
(To do it select 'Requires' string, Click add button, browse dclmid.dcp package and 
click 'Ok'.)
Recompile package.
There are no new component here. To show ClientDataSet edit window 
doubleclick on TClientDataSet component or any component that inherited 
from TCustomClientDataSet.