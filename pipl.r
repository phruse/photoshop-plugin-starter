// Portions of this code rights reserved by Copyright 1993-2002 Adobe Systems Incorporated of.
// reference - AutomationFilterPiPL.r

#include "PIDefines.h"
#include "PIResourceDefines.h"

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

resource 'PiPL' ( RESOURCE_ID, PLUGIN_NAME, purgeable)
{
		{
		Kind { Actions },
		Name { PLUGIN_NAME },
		Category { "AdobeSDK" },
		Version { (latestActionsPlugInVersion << 16) | latestActionsPlugInSubVersion },

		Component { ComponentNumber, PLUGIN_NAME },


        #ifdef Macintosh
            #if defined(__arm64__)
                CodeMacARM64 { "AutoPluginMain" },
            #endif
            #if defined(__x86_64__)
                CodeMacIntel64 { "AutoPluginMain" },
            #endif
        #elif MSWindows
            CodeEntryPointWin64 { "PluginMain" },
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

resource 'aete' (RESOURCE_ID, PLUGIN_NAME " dictionary", purgeable)
	{
	1, 0, english, roman,					/* aete version and language specifiers */
		{
		VENDOR_NAME,							/* vendor suite name */
        DESCRIPTION,		                /* optional description */
		SUITE_ID,	                        /* suite ID */
		1,									/* suite code, must be 1 */
		1,									/* suite level, must be 1 */
			{								/* structure for automation */
            PLUGIN_NAME,		                    /* name */
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