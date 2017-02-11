// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Kbmmemreseng.pas' rev: 11.00

#ifndef KbmmemresengHPP
#define KbmmemresengHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Kbmmemreseng
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
#define kbmMasterlinkErr "Number of masterfields doesn't correspond to number of ind"\
	"exfields."
#define kbmSelfRef "Selfreferencing master/detail relations not allowed."
#define kbmFindNearestErr "Can't do FindNearest on non sorted data."
#define kbminternalOpen1Err "Fielddef "
#define kbminternalOpen2Err " Datatype %d not supported."
#define kbmReadOnlyErr "Field %s is read only"
#define kbmVarArrayErr "Values variant array has invalid dimension count"
#define kbmVarReason1Err "More fields than values"
#define kbmVarReason2Err "There must be at least one field"
#define kbmBookmErr "Bookmark %d not found."
#define kbmUnknownFieldErr1 "Unknown field type (%s)"
#define kbmUnknownFieldErr2 " in CSV file. (%s)"
#define kbmIndexErr "Can't index on field %s"
#define kbmEditModeErr "Dataset is not in edit mode."
#define kbmDatasetRemoveLockedErr "Dataset being removed while locked."
#define kbmSetDatasetLockErr "Dataset is locked and cant be changed."
#define kbmOutOfBookmarks "Bookmark counter is out of range. Please close and reopen "\
	"table."
#define kbmIndexNotExist "Index %s does not exist"
#define kbmKeyFieldsChanged "Could'nt perform operation since key fields changed."
#define kbmDupIndex "Duplicate index value. Operation aborted."
#define kbmMissingNames "Missing Name or FieldNames in IndexDef!"
#define kbmInvalidRecord "Invalid record "
#define kbmTransactionVersioning "Transactioning requires multiversion versioning."
#define kbmNoCurrentRecord "No current record."
#define kbmCantAttachToSelf "Cant attach memorytable to it self."
#define kbmCantAttachToSelf2 "Cant attach to another table which itself is an attachment"\
	"."
#define kbmUnknownOperator "Unknown operator (%d)"
#define kbmUnknownFieldType "Unknown fieldtype (%d)"
#define kbmOperatorNotSupported "Operator not supported (%d)."
#define kbmSavingDeltasBinary "Saving deltas is supported only in binary format."
#define kbmCantCheckpointAttached "Cannot checkpoint attached table."
#define kbmDeltaHandlerAssign "Delta handler is not assigned to any memorytables."
#define kbmOutOfRange "Out of range (%d)"
#define kbmInvArgument "Invalid argument."
#define kbmInvOptions "Invalid options."
#define kbmTableMustBeClosed "Table must be closed for this operation."
#define kbmChildrenAttached "Children are attached to this table."
#define kbmIsAttached "Table is attached to another table."
#define kbmInvalidLocale "Invalid locale."
#define kbmInvFunction "Invalid function name %s"
#define kbmInvMissParam "Invalid or missing parameter for function %s"
#define kbmNoFormat "No format specified."
#define kbmTooManyFieldDefs "Too many fielddefs. Please raise KBM_MAX_FIELDS value."
#define kbmCannotMixAppendStructure "Cannot both append and copy structure."

}	/* namespace Kbmmemreseng */
using namespace Kbmmemreseng;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Kbmmemreseng
