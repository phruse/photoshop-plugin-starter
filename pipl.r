// Portions of this code rights reserved by Copyright 1993-2002 Adobe Systems Incorporated of.
// reference - AutomationFilterPiPL.r

#include "PIDefines.h"
#include "define.h"

#ifdef __PIMac__
	#include "PIGeneral.r"
    #include "PIUtilities.r"
#elif defined(__PIWin__)
	#define Rez
	#include "PIGeneral.h"
	#include "PIUtilities.r"
#endif

#include "PITerminology.h"
#include "PIActions.h"

resource 'PiPL' ( RESOURCE_ID, NAME, purgeable)
	{
		{
		Kind { Actions },
		Name { NAME },
		Category { "AdobeSDK" },
		Version { (latestActionsPlugInVersion << 16) | latestActionsPlugInSubVersion },

		Component { ComponentNumber, NAME },

		#ifdef __PIMac__
			CodeMacIntel64 { "AutoPluginMain" },
		#else
			#if defined(_WIN64)
				CodeWin64X86 { "AutoPluginMain" },
			#else
				CodeWin32X86 { "AutoPluginMain" },
			#endif
		#endif

		EnableInfo { "true" },

		HasTerminology
			{
			CLASS_ID,
			EVENT_ID,
			RESOURCE_ID,
            UUID
			},
		}
	};

//-------------------------------------------------------------------------------
//	Dictionary (scripting) resource
//-------------------------------------------------------------------------------
resource 'aete' (RESOURCE_ID, NAME " dictionary", purgeable)
	{
	1, 0, english, roman,					/* aete version and language specifiers */
		{
		VENDOR_NAME,							/* vendor suite name */
        DESCRIPTION,		                /* optional description */
		SUITE_ID,	                        /* suite ID */
		1,									/* suite code, must be 1 */
		1,									/* suite level, must be 1 */
			{								/* structure for automation */
			NAME,		                    /* name */
            DESCRIPTION,		            /* optional description */
			CLASS_ID,		                /* class ID, must be unique or Suite ID */
			EVENT_ID,		                /* event ID, must be unique */

			NO_REPLY,						/* never a reply */
			IMAGE_DIRECT_PARAMETER,			/* direct parameter, used by Photoshop */
				{							// filter or selection class here:
				}
			},
			{},	                            /* non-filter/automation plug-in class here */
			{},                             /* comparison ops (not supported) */
			{                               // Enumerations go here:
			}	                            /* end of any enumerations */
		}
	};