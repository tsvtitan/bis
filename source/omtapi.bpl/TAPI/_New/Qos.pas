{******************************************************************}
{                                                                  }
{       Borland Delphi Runtime Library                             }
{       Quality of Service interface unit                          }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ Portions created by Karl Mekelburg      			   }
{ Copyright (C) 2003-2004 Karl Mekelburg.   			   }
{                                                                  }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}
unit Qos;

{$WEAKPACKAGEUNIT}

interface

{$ObjExportAll On}

{$HPPEMIT ''}
{$HPPEMIT '#include <qos.h>'}
{$HPPEMIT ''}
{$HPPEMIT '#include <windows.h>'}
{$HPPEMIT '#pragma pack(1)'}

uses Windows;

 // Definitions for valued-based Service Type for each direction of data flow.
type SERVICETYPE = ULONG;
     {$EXTERNALSYM SERVICETYPE}
const
  SERVICETYPE_NOTRAFFIC            = $00000000;  //No data in this direction
  {$EXTERNALSYM SERVICETYPE_NOTRAFFIC}
  SERVICETYPE_BESTEFFORT           = $00000001;  // Best Effort
  {$EXTERNALSYM SERVICETYPE_BESTEFFORT}
  SERVICETYPE_CONTROLLEDLOAD       = $00000002;  // Controlled Load
  {$EXTERNALSYM SERVICETYPE_CONTROLLEDLOAD}
  SERVICETYPE_GUARANTEED           = $00000003;  // Guaranteed
  {$EXTERNALSYM SERVICETYPE_GUARANTEED}
  SERVICETYPE_NETWORK_UNAVAILABLE  = $00000004;  // Used to notify change to user
  {$EXTERNALSYM SERVICETYPE_NETWORK_UNAVAILABLE}
  SERVICETYPE_GENERAL_INFORMATION  = $00000005;  // corresponds to
  {$EXTERNALSYM SERVICETYPE_GENERAL_INFORMATION}//  "General Parameters"
                                                //  defined by IntServ
  SERVICETYPE_NOCHANGE             = $00000006;  // used to indicate
  {$EXTERNALSYM SERVICETYPE_NOCHANGE}           //  that the flow spec
                                                //  contains no change
                                                //  from any previous one
  SERVICETYPE_NONCONFORMING        = $00000009;  // Non-Conforming Traffic
  {$EXTERNALSYM SERVICETYPE_NONCONFORMING}
  SERVICETYPE_NETWORK_CONTROL      = $0000000A;  // Network Control traffic
  {$EXTERNALSYM SERVICETYPE_NETWORK_CONTROL}
  SERVICETYPE_QUALITATIVE          = $0000000D; // Qualitative applications
  {$EXTERNALSYM SERVICETYPE_QUALITATIVE}

//*********  The usage of these is currently not supported.  ***************/
  SERVICE_BESTEFFORT               = $80010000;
  {$EXTERNALSYM SERVICE_BESTEFFORT}
  SERVICE_CONTROLLEDLOAD           = $80020000;
  {$EXTERNALSYM SERVICE_CONTROLLEDLOAD}
  SERVICE_GUARANTEED               = $80040000;
  {$EXTERNALSYM SERVICE_GUARANTEED}
  SERVICE_QUALITATIVE              = $80200000;
   {$EXTERNALSYM SERVICE_QUALITATIVE}

// Flags to control the usage of RSVP on this flow.
// to turn off traffic control, 'OR' ( | ) this flag with the
// ServiceType field in the FLOWSPEC

  SERVICE_NO_TRAFFIC_CONTROL       =$81000000;
  {$EXTERNALSYM SERVICE_NO_TRAFFIC_CONTROL}

//
// this flag can be used to prevent any rsvp signaling messages from being
// sent. Local traffic control will be invoked, but no RSVP Path messages
// will be sent.This flag can also be used in conjunction with a receiving
// flowspec to suppress the automatic generation of a Reserve message.
// The application would receive notification that a Path  message had arrived
// and would then need to alter the QOS by issuing WSAIoctl( SIO_SET_QOS ),
// to unset this flag and thereby causing Reserve messages to go out.
//

  SERVICE_NO_QOS_SIGNALING      =$40000000;
  {$EXTERNALSYM SERVICE_NO_QOS_SIGNALING}

// Flow Specifications for each direction of data flow.
type
  PFlowSpec = ^TFlowSpec;
  _flowspec = packed record
    TokenRate: ULONG;          // In Bytes/sec
    TokenBucketSize: ULONG;    // In Bytes
    PeakBandwidth: ULONG;      // In Bytes/sec
    Latency: ULONG;            // In microseconds
    DelayVariation: ULONG;     // In microseconds
    ServiceType: SERVICETYPE;
    MaxSduSize: ULONG;         // In Bytes
    MinimumPolicedSize: ULONG; //In Bytes
  end;
  {$EXTERNALSYM _flowspec}
  TFlowSpec = _flowspec;
  FLOWSPEC = _flowspec;
  {$EXTERNALSYM FLOWSPEC}

implementation  

end.

