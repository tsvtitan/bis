{ Created May 26, 2003 by Mark Ericksen }

o - Origins of Files
o - Purpose of Files
o - Information Sources


======================================================
=== Origins of files                               ===
======================================================

The following files were originally created by Martin Waldenburg:
(http://home.t-online.de/home/Martin.Waldenburg/)

dws_mwDirectiveLex.pas
dws_mwPasLex.pas
dws_mwPasLexTypes.pas
dws_mwPasToRtf.pas
dws_mwSimplePasPar.pas
dws_mwSimplePasParTypes.pas
dws_mwTreeList.pas

All other files were created by Mark Ericksen. These include:

SourceParserTree.pas


The "mw" (Martin Waldenburg) files were taken from various sources on the net. 
Portions of the code came from "http://www.innercircleproject.org/folders/09_mwParser"
listed as the "official" source of mwParser. However, it has not been maintained 
and conflicting newsgroup postings lead me to believe that it has no official home.

Martin commented that CodeLens (http://sourceforge.net/projects/codelens) was where 
they were being maintained. (See http://www.geocrawler.com/archives/3/3421/2002/10/0/9880677/)
Unfortunately there has been no active development there for some time at the time of this
writing. I have made modifications to several of the "mw" files and where applicable
a "// MAE" was introduced to signify where the change was made. 

The "dws_mw*" files have had the "dws_" prepended to the names. As there is no official
home for them, there is no definitive source. So, the files were renamed to prevent 
collisions with other projects that may use these files as well.

======================================================
=== Purpose of files                               ===
======================================================
These files are used to parse existing pascal (Delphi) code so it can be used for Design-
time alteration and control of project code. Packages have been created for these files
so multiple design-time editors can be loaded and take advantage of them at the same time.


======================================================
=== Information Sources                            ===
======================================================

"Official" home of mwParser
http://www.innercircleproject.org/folders/09_mwParser

See the full long link for a large discussion about this topic. Martin was involved a great deal.
http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&oe=UTF-8&frame=right&rnum=1&thl=0,1367913105,1367913014,1367878091,1367872730,1367695987,1367683149,1367661049,1367581498,1367569528,1367534317,1367364981&seekm=3b2da035_2%40dnews#link1

Martin Waldenburg commenting on CodeLens having most current code.
http://www.geocrawler.com/archives/3/3421/2002/10/0/9880677/