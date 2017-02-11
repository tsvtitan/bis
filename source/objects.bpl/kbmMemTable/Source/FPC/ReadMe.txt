FreePascal support
==================

Please make sure to read the license agreement for kbmMemTable BEFORE using kbmMemTable!
Components4Developers and the author accepts _NO_ responsibility for any problems or
damages or expenses/costs related to bugs or features in kbmMemTable or the lack theirof.

Requirements:
-------------

FreePascal v. 2.1.4:
  Due to the continous evolution of FreePascal, this document, or the kbmMemTable port, 
  may not be correct for later versions of FreePascal!

kbmMemTable v. 5.53 or newer:
  v. 5.53 contains the changes needed to be compatible with FreePascal.

Compilation of kbmMemTable:
---------------------------

1) Make sure that the FreePascal bin\i386-win32 directory is listed as 
one of the first in the PATH environment variable.

2) Switch to the FPC directory under the kbmMemTable install directory.

3) If you are using a different install directory or a different version of FreePascal than
specified in this document, you will have to change the fpcdir path in all Makefile.fpc
files (for kbmMemTable and the demo).
After changing those, the Makefile files now need to be regenerated.
In each directory containing a Makefile.fpc do:
Run: fpcmake 
  
4) If you have already compiled kbmMemTable before and want to do a complete recompile.
Run: make clean

5) Now we let the compiler compile kbmMemTable.
Run: make

This will leave .o and .ppu files in a subdirectory under units. The name of 
the subdirectory depends on the chosen compiler output.

If this produce lots of errors like: 'Error makefile xxxx: Command syntax error' it indicates
that you are using the wrong version of make. Most likely you are getting
the Borland/CodeGear make utility instead of the one provided with FPC.
Try to prefix with the full path. Eg. 

c:\fpc\2.1.4\bin\i386-Win32\make

5) Now we ask 'make' to copy the compiled object files to FreePascals library.
Run: make install

6) It may actually have copied the files to c:\pp\units\i386-win32\kbmMemFPCRun instead
of the main FPC directory. If so, manually move the kbmMemFPCRun directory to
c:\FPC\2.1.4\units\i386-win32 directory.

Now you are ready to use kbmMemTable in your FPC projects.

Compilation for other targets than Intel/Win32 has not been tested.
In case you test this, please let us know the result!

Compilation of the demo application
-----------------------------------

1) Follow step 1 to 3 in the kbmMemTable compilation directions.

2) Switch to the demo subdirectory.

3) Now compile the application.
Run: make all

That should leave you an executable (demo.exe) in the subdirectory FPC/win32,
which you can run.
The demo simply creates some rows, and saves those to a CSV file.

Whats not supported?
--------------------

- TField.EditMask do not exist in FPC. Hence an empty string will be streamed, and
  any provided EditMask in a stream will be ignored.
- Filter expressions are not supported at all as FPC do not support TExprParser.
  OnFilterRecord is supported. Places where a filter expression could be provided
  has been disabled. AddFilteredIndex ignores the provided filter expression.
- ftTimeStamp fields is not supported by PopulateField. That means that
  its not possible to for example Locate on that type field.
- Nested fields are not supported as FPC do not provide support for that.
- TField.FullName do not exist in FPC.
- SetBlockReadSize is not supported by FPC.
- ftOraTimestamp and ftOraInterval are not supported by FPC.

How to recompile FPC if needed
------------------------------
  To get it, first download a FreePascal binary distribution.
  Install it in default install directory.
  Then download the latest FreePascal source version and install it
  in a seperate directory.
  Setup PATH to point at the FreePascal binary distribution bin directory.
  Make sure that the FreePascal directory is specified before any other directories
  containing 'make' etc. (like Borland/CodeGear directories).
  Change directory to the latest FreePascal source directory.
  Run: make all
  After some time, run: make install
  After some time, run: make zipinstall
  Extract the generated zip file into the FreePascal binary distribution directory,
  overwriting files that have same name.
  Now you should have the latest FreePascal version available on your machine.
  Try it out by typing:
    fpc.exe

  It should show the correct compiler version.

