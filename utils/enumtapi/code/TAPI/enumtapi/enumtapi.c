// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (C) 1995  Microsoft Corporation.  All Rights Reserved.

/*-------------------------------------------------*\

EnumTapi is a sample console app that enumerates all the devices 
made available by TAPI and prints relavent information on each one.

Whether a line is actually capable of datamodem or automatedvoice
depends on what specific capabilities are used by a specific application.
The checks made by this sample are fairly generic, so there isn't a 
guarentee that any specific app will work.

This app could be tailored to check the needs of any specific
application and would make a simple but usefull tech-support tool.

This app will only run with TAPI API Version 1.4 or later.  
This means Windows 95, Windows NT 4.0 or later versions of TAPI.

\*-------------------------------------------------*/

#pragma comment(linker, "/subsystem:console")
#pragma comment(lib, "tapi32")

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

void __cdecl MyPrintf(LPCTSTR lpszFormat, ...);
LPCTSTR FormatError(DWORD dwError);
LPCTSTR FormatErrorBuffer(DWORD dwError, LPTSTR lpszBuff, DWORD dwNumChars);
BOOL WINAPI HandlerRoutine(DWORD dwCtrlType);

// This version doesn't exist, so it's a bad thing to do!  
// You never know what you're going to get in future versions.
// Only done here because we're querying TAPI and not doing anything complex.
#define TAPI_MAX_VERSION 0x0FFF0FFF

// Make sure to compile TAPI.H so that we can use all functions
#define TAPI_CURRENT_VERSION TAPI_MAX_VERSION

#include <tapi.h>

// However, use version 1.4 as much as possible
#define TAPI_REAL_VERSION 0x00010004


#define TAPI_SUCCESS 0

// TAPI global variables.
HLINEAPP hLineApp;
DWORD dwNumDevs;
long lReturn;

typedef struct MySimpleVarString_tag
{
   VARSTRING;
   DWORD handle;
   TCHAR szString[256];
} MYSIMPLEVARSTRING;

MYSIMPLEVARSTRING SmallVarString;
LINEDEVSTATUS LineDevStatus;
LPLINEDEVCAPS lpLineDevCaps = NULL;

LPLINEPROVIDERLIST lpLineProviderList = NULL;
LPLINEPROVIDERENTRY lpLineProviderEntry;

#define BIG_STRUCT_SIZE 4096

// message strings.  These should probably be resources instead.

TCHAR szAppName[]          = TEXT("EnumTapi");

TCHAR szLineUnavail[]      = TEXT("Line Unavailable");
TCHAR szLineUnnamed[]      = TEXT("Line Unnamed");
TCHAR szLineNameEmpty[]    = TEXT("Line Name is Empty");

TCHAR szProviderUnknown[]  = TEXT("Provider Unknown");


// Prototypes
void CALLBACK lineCallbackFunc(
    DWORD dwDevice, DWORD dwMsg, DWORD dwCallbackInstance, 
    DWORD dwParam1, DWORD dwParam2, DWORD dwParam3);
void PrintTapiLines(DWORD dwDeviceID);
void PrintModemInfo(DWORD i);
char * FormatLineError (long lError);



DWORD dwTAPIVersion = TAPI_CURRENT_VERSION;

// Main entry point.

int main(int argc, char **argv)
{
   DWORD i;
   LINEINITIALIZEEXPARAMS li;
   BOOL bModemInfo = FALSE;

   if ((argc > 1) && (0 == lstrcmp(argv[1], "-m")))
      bModemInfo = TRUE;

   li.dwTotalSize = sizeof(li);
   li.dwOptions = LINEINITIALIZEEXOPTION_USEHIDDENWINDOW;

   lReturn = lineInitializeEx(&hLineApp, NULL, lineCallbackFunc, szAppName, &dwNumDevs, &dwTAPIVersion, &li);

   if (lReturn != TAPI_SUCCESS)
   {
      dwTAPIVersion = 0x00010004;
      lReturn = lineInitialize(&hLineApp, GetModuleHandle(NULL), 
         lineCallbackFunc, szAppName, &dwNumDevs);
   }

   if (lReturn != TAPI_SUCCESS)
   {
      MyPrintf("lineInitialize failed: %s.\n", FormatLineError(lReturn));
      return 0;
   }

   MyPrintf("Installed TAPI Version is %lu.%lu\n", dwTAPIVersion>>16, dwTAPIVersion&0x0000FFFF);

   lpLineDevCaps      = LocalAlloc(LPTR, BIG_STRUCT_SIZE);
   lpLineProviderList = LocalAlloc(LPTR, BIG_STRUCT_SIZE);
   lpLineDevCaps     -> dwTotalSize = BIG_STRUCT_SIZE;
   lpLineProviderList-> dwTotalSize = BIG_STRUCT_SIZE;
   LineDevStatus      . dwTotalSize = sizeof(LineDevStatus);
   SmallVarString     . dwTotalSize = sizeof(SmallVarString);

   // Get the Provider List so its possible to associate a line device
   // with a specific service provider later.
   while(TRUE)
   {
      lReturn = lineGetProviderList(dwTAPIVersion, lpLineProviderList);
      if (lReturn)
      {
         MyPrintf("lineGetProviderList failed: %s\n", FormatLineError(lReturn));
         break;
      }

      if (lpLineProviderList->dwNeededSize <= lpLineProviderList->dwTotalSize)
         break; // Got it all

      lpLineProviderList = 
         LocalReAlloc(lpLineProviderList, 
            lpLineProviderList->dwNeededSize, LMEM_MOVEABLE);
      lpLineProviderList->dwTotalSize = lpLineProviderList->dwNeededSize;
   }

   lpLineProviderEntry = (LPLINEPROVIDERENTRY)
      ((BYTE *) lpLineProviderList + 
         lpLineProviderList->dwProviderListOffset);

   MyPrintf(
      "Installed TAPI Service Providers\n"
      "<- dwPermanentProviderID\n"
      "           <- ProviderFilename\n");
   for(i = 0; i < lpLineProviderList->dwNumProviders; i++)
   {
      MyPrintf("0x%08X %s\n", lpLineProviderEntry[i].dwPermanentProviderID, 
         (LPTSTR) lpLineProviderList + lpLineProviderEntry[i].dwProviderFilenameOffset);
   }


   if (dwNumDevs)
   {
      MyPrintf(
         "\nInstalled TAPI line Devices\n"
         "<- dwDeviceID\n"
         "|   <- Max dwAPIVersion\n"
         "|   |    <- dwNumAddresses\n"
         "|   |    |  <- dwPermanentLineID\n"
         "|   |    |  |           <- Capable of making voice comm/datamodem calls?\n"
         "|   |    |  |           |  <- Capable of making automated voice calls?\n"
         "|   |    |  |           |  |  <- Call in progress?\n"
         "|   |    |  |           |  |  |  <- Any application waiting for calls?\n"
         "|   |    |  |           |  |  |  |  <- Service Povider - Line Device Name\n"
         "V   V    V  V           V  V  V  V\n"
         );
      for (i=0;i<dwNumDevs;i++)
      {
         PrintTapiLines(i);
      }

      if (bModemInfo)
         for (i = 0; i < dwNumDevs; i++)
         {
            PrintModemInfo(i);
         }
   }
   else
      MyPrintf("No TAPI Line devices installed.\n");

   lineShutdown(hLineApp);
   LocalFree(lpLineDevCaps);
   LocalFree(lpLineProviderList);

   return 1;
}

void PrintTapiLines(DWORD dwDeviceID)
{
   BOOL bSupportsDataComm = TRUE;
   BOOL bSupportsAutomatedVoice = TRUE;

   DWORD dwApiVersion;
   LINEEXTENSIONID ExtensionID;
   HLINE hLine;
   DWORD dwAddressID = 0;
   char * lpszLineName;
   DWORD dwCount;
   DWORD dwProviderID;

   MyPrintf("%-2lu, ", dwDeviceID);

   // Find the max API Version supported.
   // Note that this is normally a bad thing to do!!!
   // Usually, you use an API Version that you know your app can support.
   lReturn = lineNegotiateAPIVersion (hLineApp, dwDeviceID,
      0x00010003, TAPI_MAX_VERSION, &dwApiVersion, &ExtensionID);

   if (lReturn)
   {
      MyPrintf("lineNegotiateAPIVersion error: %s\n", FormatLineError(lReturn));
      return;
   }

   MyPrintf("%lu.%lu, ", dwApiVersion>>16, dwApiVersion&0x0000FFFF);

   while(TRUE)
   {
      lReturn = lineGetDevCaps(hLineApp, dwDeviceID, 
         dwApiVersion, 0, lpLineDevCaps);

      if (lReturn)
      {
         MyPrintf("lineGetDevCaps error: %s\n", FormatLineError(lReturn));
         return;
      }

      if (lpLineDevCaps->dwNeededSize > lpLineDevCaps->dwTotalSize)
      {
         lpLineDevCaps = 
            LocalReAlloc(lpLineDevCaps, 
               lpLineDevCaps->dwNeededSize, LMEM_MOVEABLE);
         lpLineDevCaps->dwTotalSize = lpLineDevCaps->dwNeededSize;
         continue;
      }
      
      break;
   }

   // Print number of available addresses..
   MyPrintf("%lu, ", lpLineDevCaps->dwNumAddresses);

   // Print permanent line ID
   MyPrintf("0x%08lX, ", lpLineDevCaps->dwPermanentLineID);

   // Check to see if basic data/voice capabilities are available.
   if (!(lpLineDevCaps->dwBearerModes & LINEBEARERMODE_VOICE ))
      bSupportsDataComm = FALSE;

   if (!((lpLineDevCaps->dwBearerModes & LINEBEARERMODE_VOICE ) ||
         (lpLineDevCaps->dwBearerModes & LINEBEARERMODE_SPEECH )))
      bSupportsAutomatedVoice = FALSE;

   if (!(lpLineDevCaps->dwMediaModes & LINEMEDIAMODE_DATAMODEM))
      bSupportsDataComm = FALSE;

   if (!(lpLineDevCaps->dwMediaModes & LINEMEDIAMODE_AUTOMATEDVOICE))
      bSupportsAutomatedVoice = FALSE;

   // Make sure it is possible to make a call.
   if (!(lpLineDevCaps->dwLineFeatures & LINEFEATURE_MAKECALL))
   {
      bSupportsDataComm = FALSE;
      bSupportsAutomatedVoice = FALSE;
   }

   // Have to open the line to check specific device classes.
   lReturn = lineOpen(hLineApp, dwDeviceID, &hLine,
      dwApiVersion, 0, 0, LINECALLPRIVILEGE_NONE, 0, 0);

   if (lReturn)
   {
      MyPrintf("lineOpen error: %s\n", FormatLineError(lReturn));
      return;
   }

   // Make sure the "comm/datamodem" device class is supported
   lReturn = lineGetID(hLine, 0, 0, LINECALLSELECT_LINE,
      (VARSTRING*)&SmallVarString, "comm/datamodem");

   if (lReturn)
      bSupportsDataComm = FALSE;
   else
      CloseHandle((HANDLE) SmallVarString.handle);

   // Print the comm/datamodem results.
   if (bSupportsDataComm)
      MyPrintf("Y, ");
   else
      MyPrintf("N, ");

   // Make sure both "wave/in" and "wave/out" device classes are supported.
   lReturn = lineGetID(hLine, 0, 0, LINECALLSELECT_LINE,
      (VARSTRING*)&SmallVarString, "wave/in");
   if (lReturn)
      bSupportsAutomatedVoice = FALSE;
   else
   {
      lReturn = lineGetID(hLine, 0, 0, LINECALLSELECT_LINE,
         (VARSTRING*)&SmallVarString, "wave/out");
      if (lReturn)
         bSupportsAutomatedVoice = FALSE;
   }

   // Print the automatedvoice results.
   if (bSupportsAutomatedVoice)
      MyPrintf("Y, ");
   else
      MyPrintf("N, ");

   lReturn = lineGetLineDevStatus(hLine, &LineDevStatus);
   if (lReturn)
   {
      MyPrintf("?, ?, ");
   }
   else
   {
      // Any calls in progress?
      if (LineDevStatus.dwNumActiveCalls ||
          LineDevStatus.dwNumOnHoldCalls ||
          LineDevStatus.dwNumOnHoldPendCalls)
         MyPrintf("Y, ");
      else
         MyPrintf("N, ");

      // Any apps waiting for calls?
      if (LineDevStatus.dwOpenMediaModes)
         MyPrintf("Y, ");
      else
         MyPrintf("N, ");
   }

   // Track down the Service Provider that owns this line device.

   lReturn = lineGetID(hLine, 0, 0, LINECALLSELECT_LINE,
      (VARSTRING*)&SmallVarString, "tapi/providerid");
   if (lReturn)
      dwProviderID = HIWORD(lpLineDevCaps->dwPermanentLineID);
   else
      dwProviderID = SmallVarString.handle;

   // Looking for: HIWORD(dwPermanentLineID) == dwPermanentProviderID
   dwCount = lpLineProviderList->dwNumProviders;
   while(dwCount--)
   {
      if (dwProviderID == lpLineProviderEntry[dwCount].dwPermanentProviderID)
      {
         MyPrintf("%s - ", (char *)
            ((BYTE *) lpLineProviderList + 
               lpLineProviderEntry[dwCount].dwProviderFilenameOffset));
         dwCount = 1;
         break;
      }
   }
   if (dwCount != 1)
      MyPrintf("%s - ", szProviderUnknown);

   // Find the name of the line device
  if ((lpLineDevCaps -> dwLineNameSize) &&
       (lpLineDevCaps -> dwLineNameOffset) &&
       (lpLineDevCaps -> dwStringFormat == STRINGFORMAT_ASCII))
   {
      TCHAR szName[512];
      CopyMemory((PVOID) szName,
         (PVOID) ((BYTE *) lpLineDevCaps + lpLineDevCaps -> dwLineNameOffset), 
         lpLineDevCaps->dwLineNameSize);
      lpszLineName = szName;

      if (lpszLineName[0] != '\0')
      {
         // In case the device name is not null terminated, add one.
         // Bug in the TSP, but fixable here.
         lpszLineName[lpLineDevCaps->dwLineNameSize] = '\0';
      }
      else // Line name started with a NULL.
         lpszLineName = szLineNameEmpty;
   }
   else  // DevCaps doesn't have a valid line name.  Unnamed.
      lpszLineName = szLineUnnamed;

   MyPrintf("%s",lpszLineName);

   {
      BYTE Buff[1024];
      LPVARSTRING pVarString = (LPVARSTRING) Buff;
      LPTSTR pszPortName = (LPTSTR) (Buff +sizeof(VARSTRING));
      pVarString->dwTotalSize = sizeof(Buff);

      if ((0 == lineGetID(hLine, 0, 0, LINECALLSELECT_LINE, pVarString, TEXT("comm/datamodem/portname"))) &&
          (*pszPortName != TEXT('\0')))
      {
         MyPrintf(TEXT(" - %s"), pszPortName);
      }
   }

   MyPrintf("\n");
   lineClose(hLine);
}

void PrintModemInfo(DWORD i)
{
   LONG lRet;
   HLINE hLine;

   BYTE VarBuff[1024];
   LPVARSTRING lpVarString = (LPVARSTRING) VarBuff;
   LPTSTR pszOut = (LPTSTR) VarBuff; // Re-using the buffer

   HANDLE hFile;
   BYTE Buff[sizeof(COMMPROP) + sizeof(MODEMSETTINGS) + 4096] = {0};
   USHORT dwSize = sizeof(Buff);
   COMMPROP *pcp = (COMMPROP *) Buff;
   PMODEMDEVCAPS pmdc = (PMODEMDEVCAPS) &pcp->wcProvChar;

   lpVarString->dwTotalSize = sizeof(VarBuff);

   // We have to open with OWNER on Win9x to get modem info.
   // Not true on other platforms.
   lRet = lineOpen(hLineApp, i, &hLine, 0x00010004, 
      0, 0, LINECALLPRIVILEGE_OWNER, LINEMEDIAMODE_DATAMODEM,
      NULL);
   if (lRet != 0)
   {
      MyPrintf(TEXT("Not a modem: lineOpen on device %lu failed with %s\r\n"), i, FormatLineError(lRet));
      return;
   }

   // Fill the VARSTRING structure
   lRet = lineGetID(hLine, 0, 0, LINECALLSELECT_LINE, lpVarString, TEXT("comm/datamodem"));
   if (lRet != 0)
   {
      MyPrintf(TEXT("Not a modem: lineGetId on %lu failed with %s\r\n"), i, FormatLineError(lRet));
      return;      
   }

   hFile = *((LPHANDLE)((LPBYTE)lpVarString + lpVarString -> dwStringOffset));

   // Initialize the structure
   pcp->wPacketLength = dwSize;
   pcp->dwProvSubType = PST_MODEM;
   pcp->dwProvSpec1 = COMMPROP_INITIALIZED;

   if (!GetCommProperties(hFile, pcp))
   {
      MyPrintf(TEXT("Not a modem: GetCommProperties on %lu failed with %s\r\n"), i, FormatError(GetLastError()));
      return;
   }

   if (pcp->dwProvSubType != PST_MODEM)
   {
      MyPrintf(TEXT("Note a modem: COMMPROP.dwProvSubType != PST_MODEM on device %lu\r\n"), i);
      return;
   }

   if (pmdc->dwModemManufacturerOffset && pmdc->dwModemManufacturerSize)
   {
      memcpy(VarBuff, (LPVOID)(((LPBYTE) pmdc) + pmdc->dwModemManufacturerOffset), pmdc->dwModemManufacturerSize);
      pszOut[pmdc->dwModemManufacturerSize] = TEXT('\0');

// On NT, this string will probably be Unicode rather than ANSI
#ifndef UNICODE
      if ((VarBuff[1] == 0) && (pmdc->dwModemManufacturerSize > 1))
      {
         // Convert from Unicode to ANSI
         CHAR szAnsi[1024];
         wcstombs(szAnsi, (wchar_t *) VarBuff, 1024);
         lstrcpy(pszOut, szAnsi);
      }
#endif

      MyPrintf(TEXT("Device %lu is a modem, Manufacturer: %s\r\n"), i, pszOut);
   }
   else
      MyPrintf(TEXT("Device %lu is probably a modem, MODEMDEVCAPS.dwModemManufacturer is empty\r\n"), i);

   return;
}

void CALLBACK lineCallbackFunc(
    DWORD dwDevice, DWORD dwMsg, DWORD dwCallbackInstance, 
    DWORD dwParam1, DWORD dwParam2, DWORD dwParam3)
{
   // Not used for anything.
}


// Turn a TAPI Line error into a printable string.
char * FormatLineError (long lError)
{
   static LPSTR pszLineError[] = 
   {
      "LINEERR No Error",
      "LINEERR_ALLOCATED",
      "LINEERR_BADDEVICEID",
      "LINEERR_BEARERMODEUNAVAIL",
      "LINEERR Unused constant, ERROR!!",
      "LINEERR_CALLUNAVAIL",
      "LINEERR_COMPLETIONOVERRUN",
      "LINEERR_CONFERENCEFULL",
      "LINEERR_DIALBILLING",
      "LINEERR_DIALDIALTONE",
      "LINEERR_DIALPROMPT",
      "LINEERR_DIALQUIET",
      "LINEERR_INCOMPATIBLEAPIVERSION",
      "LINEERR_INCOMPATIBLEEXTVERSION",
      "LINEERR_INIFILECORRUPT",
      "LINEERR_INUSE",
      "LINEERR_INVALADDRESS",
      "LINEERR_INVALADDRESSID",
      "LINEERR_INVALADDRESSMODE",
      "LINEERR_INVALADDRESSSTATE",
      "LINEERR_INVALAPPHANDLE",
      "LINEERR_INVALAPPNAME",
      "LINEERR_INVALBEARERMODE",
      "LINEERR_INVALCALLCOMPLMODE",
      "LINEERR_INVALCALLHANDLE",
      "LINEERR_INVALCALLPARAMS",
      "LINEERR_INVALCALLPRIVILEGE",
      "LINEERR_INVALCALLSELECT",
      "LINEERR_INVALCALLSTATE",
      "LINEERR_INVALCALLSTATELIST",
      "LINEERR_INVALCARD",
      "LINEERR_INVALCOMPLETIONID",
      "LINEERR_INVALCONFCALLHANDLE",
      "LINEERR_INVALCONSULTCALLHANDLE",
      "LINEERR_INVALCOUNTRYCODE",
      "LINEERR_INVALDEVICECLASS",
      "LINEERR_INVALDEVICEHANDLE",
      "LINEERR_INVALDIALPARAMS",
      "LINEERR_INVALDIGITLIST",
      "LINEERR_INVALDIGITMODE",
      "LINEERR_INVALDIGITS",
      "LINEERR_INVALEXTVERSION",
      "LINEERR_INVALGROUPID",
      "LINEERR_INVALLINEHANDLE",
      "LINEERR_INVALLINESTATE",
      "LINEERR_INVALLOCATION",
      "LINEERR_INVALMEDIALIST",
      "LINEERR_INVALMEDIAMODE",
      "LINEERR_INVALMESSAGEID",
      "LINEERR Unused constant, ERROR!!",
      "LINEERR_INVALPARAM",
      "LINEERR_INVALPARKID",
      "LINEERR_INVALPARKMODE",
      "LINEERR_INVALPOINTER",
      "LINEERR_INVALPRIVSELECT",
      "LINEERR_INVALRATE",
      "LINEERR_INVALREQUESTMODE",
      "LINEERR_INVALTERMINALID",
      "LINEERR_INVALTERMINALMODE",
      "LINEERR_INVALTIMEOUT",
      "LINEERR_INVALTONE",
      "LINEERR_INVALTONELIST",
      "LINEERR_INVALTONEMODE",
      "LINEERR_INVALTRANSFERMODE",
      "LINEERR_LINEMAPPERFAILED",
      "LINEERR_NOCONFERENCE",
      "LINEERR_NODEVICE",
      "LINEERR_NODRIVER",
      "LINEERR_NOMEM",
      "LINEERR_NOREQUEST",
      "LINEERR_NOTOWNER",
      "LINEERR_NOTREGISTERED",
      "LINEERR_OPERATIONFAILED",
      "LINEERR_OPERATIONUNAVAIL",
      "LINEERR_RATEUNAVAIL",
      "LINEERR_RESOURCEUNAVAIL",
      "LINEERR_REQUESTOVERRUN",
      "LINEERR_STRUCTURETOOSMALL",
      "LINEERR_TARGETNOTFOUND",
      "LINEERR_TARGETSELF",
      "LINEERR_UNINITIALIZED",
      "LINEERR_USERUSERINFOTOOBIG",
      "LINEERR_REINIT",
      "LINEERR_ADDRESSBLOCKED",
      "LINEERR_BILLINGREJECTED",
      "LINEERR_INVALFEATURE",
      "LINEERR_NOMULTIPLEINSTANCE"
   };

   _declspec(thread) static TCHAR szError[512];
   DWORD dwError;
   HMODULE hTapiUIMod = GetModuleHandle(TEXT("TAPIUI.DLL"));

   if (hTapiUIMod)
   {
      dwError = FormatMessage(FORMAT_MESSAGE_FROM_HMODULE,
                    (LPCVOID)hTapiUIMod, TAPIERROR_FORMATMESSAGE(lError),
                    0, szError, sizeof(szError)/sizeof(TCHAR), NULL);
      if (dwError)
         return szError;
   }

   // Strip off the high bit to make the error code positive.
   dwError = (DWORD)lError & 0x7FFFFFFF;

   if ((lError > 0) || (dwError > sizeof(pszLineError)/sizeof(pszLineError[0])))
   {
      wsprintf(szError, "Unknown TAPI error code: 0x%lx", lError);
      return szError;
   }

   return pszLineError[dwError];
}

/*=== Printing routines =============================================================*/

#define MAX_PRINT_STRING 1024

//#define MSG_BOX_PRINT

#ifdef _DEBUG
#define MSG_DEBUG_PRINT
#endif

#define MSG_CONSOLE_PRINT

void __cdecl MyPrintf(LPCTSTR lpszFormat, ...)
{
   _declspec(thread) static TCHAR szOutput[MAX_PRINT_STRING]; // max printable string length
   va_list v1;
   DWORD dwSize;

   va_start(v1, lpszFormat);

   dwSize = wvsprintf(szOutput, lpszFormat, v1); 

#ifdef MSG_DEBUG_PRINT
   OutputDebugString(szOutput);
#endif

#ifdef MSG_CONSOLE_PRINT
   _tprintf(szOutput);
#endif

#ifdef MSG_BOX_PRINT
   MessageBox(NULL, szOutput, "MyPrintf Output", MB_OK);
#endif
}

LPCTSTR FormatError(DWORD dwError)
{
   _declspec(thread) static TCHAR szBuff[MAX_PRINT_STRING];
   return FormatErrorBuffer(dwError, szBuff, MAX_PRINT_STRING);
}

LPCTSTR FormatErrorBuffer(DWORD dwError, LPTSTR lpszBuff, DWORD dwNumChars)
{
   DWORD dwRetFM = 0;

   dwRetFM = wsprintf(lpszBuff, TEXT("%lu - "), dwError);
   dwRetFM = FormatMessage(
      FORMAT_MESSAGE_FROM_SYSTEM, NULL, dwError, 0,
      &lpszBuff[dwRetFM], dwNumChars - dwRetFM, NULL);

   if (dwRetFM == 0)
   {
      wsprintf(lpszBuff, TEXT("FormatMessage failed on %lu with %lu"),
         dwError, GetLastError());
   }

   return lpszBuff;
}


