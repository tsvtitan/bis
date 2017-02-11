MiTeC System Information Component
==================================
(aka MSystemInfo)

Revised: 04/23/2001

Legal issues:
-------------

              Copyright © 1997-2001 by Michal Mutl 
              Aubrechtove 3102, 106 00 Praha 10, Czech republic
              <michal.mutl@atlas.cz>
              
              This software is provided 'as-is', without any express or
              implied warranty. In no event will the author be held liable
              for any damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation is required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

Register
--------
      
MSystemInfo is freeware. No registration is needed in this time. But if you find this
component usable and want to support further development you can send some money 
to following account 

Swift: KOMB CZ PP (Komerèní banka a.s.) 
Account number: 745 967 02 37 / 0100

or to this address

ing. Michal Mutl
Aubrechtove 3102
106 00 Prague 10
Czech Republic.

In this case mention your name, address and e-mail and i will send you every new 
version by e-mail.


Installation:
-------------

The zip file has subdirectories in it. You must use the pkunzip -d option
to restore this directory tree or you will have problems because the files 
will not be in their proper subdirectories.

This is the subdirectory layout:

.\                           Info directory
.\cpl                        Control Panel Applet providing System information overview using this component
.\demos                      Sample applications
.\rtl                        Wanted and missing units from Borland


DELPHI 5: Info directory contains MiTeC.dpk which is a package source for
all components. Using Delphi, do a file/open, select *.dpk and browse to
the info directory. Select MiTeC.dpk and open it. Then click on the 
Install button. You should see the MiTeC tab on the component gallery.

DELPHI 2,3,4: Info directory contains component sources. To install a component file,
do Component/Install, then click on the Add button, then click on the Browse
button and browse to the info directory. Select a component file MSystemInfo.pas and
click on OK. Do it again for all component files and finally click OK button on the
Install Component dialog window. Your library will be rebuilt. You should see the 
tab MiTeC added to your component gallery.

Support:
--------

If you have some problem or suspicion something bad, send me e-mail to 
<michal.mutl@atlas.cz> describe your problem and attach file generated
by TMSystemInfo.Report. If you cannot obtain this file add following info
to this message: OS platform and version
                 Delphi version
                 MSystemInfo version.
I will process all suggestions but reply only someones.                 

	      
Known Problems:
---------------

There's problem with device evaluation under Win95 platform, because Microsoft doesn't
provide it in full range as is under other platforms.
Another problem is obtaining cache sizes for some older Intel and Cyrix CPUs. AMD seems to work good.

Special thanks to
-----------------

- Dirk Knoblauch for sponsoring
- Chris Crowe for beta testing and more suggestions


Michal Mutl <michal.mutl@atlas.cz>