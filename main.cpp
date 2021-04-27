#include <SPBasic.h>
#include <SPInterf.h>

#include <PIActionsPlugin.h>
#include <PIUtilities.h>
#include <PIUSuites.cpp>

SPBasicSuite *sSPBasic = nullptr;

SPErr run(PSActionsPlugInMessage *message){

    /* Run */

    return kSPNoError;
}

DLLExport SPAPI SPErr AutoPluginMain(const char* caller, const char* selector, void* message) // AutoPlugin
{
    SPErr error = kSPNoError;

    try {
        auto *basicMessage = static_cast<SPMessageData*>(message);
        sSPBasic = basicMessage->basic;

        if (sSPBasic->IsEqual(caller, kSPInterfaceCaller)) { // If interface caller
            if (sSPBasic->IsEqual(selector, kSPInterfaceAboutSelector)) { // About box call
                error = kSPNoError;
            }

            if (sSPBasic->IsEqual(selector, kSPInterfaceStartupSelector)) { // Start call
                error = kSPNoError;
            }

            if (sSPBasic->IsEqual(selector, kSPInterfaceShutdownSelector)) { // Shutdown call
                PIUSuitesRelease();
                error = kSPNoError;
            }
        }

        if (sSPBasic->IsEqual(caller, kPSPhotoshopCaller)) { // If Photoshop caller
            if (sSPBasic->IsEqual(selector, kPSDoIt)) {
                auto *actionsMessage = static_cast<PSActionsPlugInMessage*>(message); // Cast to the right message
                error = run(actionsMessage);
            }
        }
    }
    catch(...)
    {
        error = kSPBadParameterError;
    }

    return error;
}