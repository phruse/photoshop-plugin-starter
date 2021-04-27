# photoshop is a trademark of their respective owners.

cmake_minimum_required(VERSION 3.16)

project("photoshopPluginStarter"
        VERSION 0.1
        DESCRIPTION "photoshop plug-in")

# Define setting value

set( Plugin_Name ${CMAKE_PROJECT_NAME})
set( Plugin_Description ${CMAKE_PROJECT_DESCRIPTION})
set( Plugin_Output_Suffix ".8bp") # pluginsdk/documentation/html/pgplugintypes.html
set( PiPL_File_Path "pipl.r" )
set( Tool_Path "${CMAKE_CURRENT_SOURCE_DIR}/tool" )
set( Cert_Path "${CMAKE_CURRENT_SOURCE_DIR}/cert" )
set( Sdk_Path "${CMAKE_CURRENT_SOURCE_DIR}/sdk")
set( Build_Tmp_Path "${CMAKE_CURRENT_SOURCE_DIR}/build" )
set( Cert_Password ${CERT_PASSWORD} ) # Add argument -DCERT_PASSWORD=password
set( Src_List "define.h"
        "main.cpp")

# Set UUID

set( NameSpace_URL "6ba7b811-9dad-11d1-80b4-00c04fd430c8" )
string(
        UUID Plugin_UUID
        NAMESPACE ${NameSpace_URL}
        NAME ${CMAKE_PROJECT_NAME}
        TYPE SHA1
)

# MSVC version check
# Tip. Don't use the compiler in Visual Studio 2019, Use Visual Studio 2017.

if(!MSVC OR MSVC_VERSION LESS 1910 OR MSVC_VERSION GREATER 1919)
    message( WARNING "MSVC v141 is essential to use to build. Other compilers will not work properly." )
endif()

# Required file list
# in tool folder (Cnvtpipl.exe, ZXPSignCmd.exe - for release)
# in cert folder (cert.p12) - for release
# in sdk folder (https://console.adobe.io/downloads/ps)
# pluginsdk/samplecode/common -> sdk/common
# pluginsdk/photoshopapi/photoshop -> sdk/photoshop
# pluginsdk/photoshopapi/pica_sp -> sdk/pica_sp

if( NOT EXISTS "${Tool_Path}/Cnvtpipl.exe" OR
        NOT EXISTS "${Sdk_Path}/common/includes" OR
        NOT EXISTS "${Sdk_Path}/common/resources" OR
        NOT EXISTS "${Sdk_Path}/common/sources" OR
        NOT EXISTS "${Sdk_Path}/photoshop" OR
        NOT EXISTS "${Sdk_Path}/pica_sp"
        )
    message( FATAL_ERROR "The required file was not found. Correct it by referring to the comments." )
endif()

# You may also need CMAKE_BUILD_TYPE.

if( NOT CMAKE_BUILD_TYPE STREQUAL "Debug" AND
        NOT EXISTS "${Cert_Path}/cert.p12" OR
        NOT EXISTS "${Tool_Path}/ZXPSignCmd.exe"
        )
    message( FATAL_ERROR "The required file for release was not found. Correct it by referring to the comments." )
endif()

# Flag push

set(CXX_FLAGS_BACKUP "${CMAKE_CXX_FLAGS}")
set(CXX_FLAGS_DEBUG_BACKUP "${CMAKE_CXX_FLAGS_DEBUG}")
set(CXX_FLAGS_RELEASE_BACKUP "${CMAKE_CXX_FLAGS_RELEASE}")
set(INCLUDE_DIRECTORIES_BACKUP ${INCLUDE_DIRECTORIES})
set(SHARED_LINKER_FLAGS_DEBUG_BACKUP "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
set(SHARED_LINKER_FLAGS_RELEASE_BACKUP "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /nologo /WX /EHsc /Zc:__cplusplus /arch:AVX2")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /D_DEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DNDEBUG")

set(EX_LIB_Linker_Flags "/defaultlib:User32.lib
                         /defaultlib:Kernel32.lib
                         /defaultlib:Shell32.lib
                         /nodefaultlib:LIBCMTD.lib
                         /nodefaultlib:LIBCMT.lib" )
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /incremental:no ${EX_LIB_Linker_Flags}
                                \"${Build_Tmp_Path}/pipl.res\" /nologo")
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /opt:noref")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /opt:ref")

set( PS_Sdk_Paths "${CMAKE_CURRENT_SOURCE_DIR}"
        "${Sdk_Path}/common/includes"
        "${Sdk_Path}/common/sources"
        "${Sdk_Path}/common/resources"
        "${Sdk_Path}/photoshop"
        "${Sdk_Path}/pica_sp"
        )

# Windows path to Unix path

string(REPLACE "/" "\\" MS_Build_Tmp_Path "${Build_Tmp_Path}")
string(REPLACE "/" "\\" MS_Build_Bin_Path "${CMAKE_CURRENT_SOURCE_DIR}/bin")
string(REPLACE "/" "\\" MS_Build_Out_Path "${CMAKE_CURRENT_SOURCE_DIR}/bin/${Plugin_Name}.zxp")
string(REPLACE "/" "\\" MS_PiPL_File_Path "${CMAKE_CURRENT_SOURCE_DIR}/${PiPL_File_Path}")

set( MS_Sdk_Paths "/I \"${Sdk_Path}/common/resources\" \
        /I \"${Sdk_Path}/common/includes\" \
        /I \"${Sdk_Path}/common/sources\" \
        /I \"${Sdk_Path}/photoshop\" \
        /I \"${Sdk_Path}/pica_sp\"")

include_directories(${PS_Sdk_Paths})

# Notice print

message( NOTICE "- Project setting")
message( NOTICE "Name        | ${Plugin_Name}")
message( NOTICE "Description | ${Plugin_Description}")
message( NOTICE "UUID        | ${Plugin_UUID}")
message( NOTICE "Output      | ${Plugin_Output_Suffix}")
message( NOTICE )

if(WIN32)

    message( STATUS "OS is Windows")

    add_definitions(/D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /DISOLATION_AWARE_ENABLED=1 /DWIN32=1
            /D_WINDOWS /D_USRDLL /D_WINDLL /D_MBCS)

#You may also need CMAKE_BUILD_TYPE.

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message( STATUS "Debug build")
    set(PH_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG} ")
else()
    message( STATUS "Release build")
    set(PH_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE} ")
endif()

    set(PiPL_DEFINE
    "/DNAME=\\\"${Plugin_Name}\\\" /DDESCRIPTION=\"\\\"${Plugin_Description}\\\"\" /DUUID=\\\"${Plugin_UUID}\\\"")

    # Build PiPL
    # PiPL -> preprocessor(.rr) -> Cvntpipl.exe(.rc) -> re.exe(.res)

    add_custom_target(PiPL ALL
            COMMENT  "Build PiPL..."
            SOURCES ${PiPL_File_Path}
            COMMAND if not exist "${MS_Build_Tmp_Path}" mkdir "${MS_Build_Tmp_Path}"
            COMMAND ${CMAKE_CXX_COMPILER} ${PH_FLAGS} ${MS_Sdk_Paths} /EP /DMSWindows=1 ${PiPL_DEFINE}
                /Tc ${MS_PiPL_File_Path} > "${Build_Tmp_Path}/pipl.rr"
            COMMAND echo .rr done (%errorlevel%)
            COMMAND ${Tool_Path}/Cnvtpipl.exe "${Build_Tmp_Path}/pipl.rr" "${Build_Tmp_Path}/pipl.rc"
            COMMAND echo .rc done (%errorlevel%)
            COMMAND rc /v /fo "${Build_Tmp_Path}/pipl.res" "${Build_Tmp_Path}/pipl.rc"
            COMMAND echo .res done (%errorlevel%)
            )

    # Build src
    # src -> .obj, .res -> Plugin_Output_Suffix( ex .8bp)

    add_library(${Plugin_Name} SHARED ${Src_List})

    add_dependencies(${Plugin_Name} PiPL)

    set_target_properties(${Plugin_Name} PROPERTIES PREFIX "")
    set_target_properties(${Plugin_Name} PROPERTIES OUTPUT_NAME ${Plugin_Name})
    set_target_properties(${Plugin_Name} PROPERTIES SUFFIX "${Plugin_Output_Suffix}")

    set_target_properties( ${Plugin_Name}
            PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${Build_Tmp_Path}"
            LIBRARY_OUTPUT_DIRECTORY "${Build_Tmp_Path}"
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
            )

    # Signing
    # /bin -> ZXPSignCmd.exe(.zxp)

    add_custom_command(TARGET ${Plugin_Name}
            POST_BUILD
            COMMAND if not exist "${MS_Build_Bin_Path}" mkdir "${MS_Build_Bin_Path}"
            COMMAND ${Tool_Path}/ZXPSignCmd.exe
                -sign "${MS_Build_Bin_Path}" "${MS_Build_Out_Path}" "${Cert_Path}/cert.p12" "${Cert_Password}"
            COMMENT "Set cert.cert..."
            VERBATIM
            )


elseif(APPLE)
    message( FATAL_ERROR "OS X not support now" )
endif()

# Flag pop

set(CMAKE_CXX_FLAGS "${CXX_FLAGS_BACKUP}")
set(CMAKE_CXX_FLAGS_DEBUG "${CXX_FLAGS_BACKUP}")
set(CMAKE_CXX_FLAGS_RELEASE "${CXX_FLAGS_BACKUP}")
set(INCLUDE_DIRECTORIES ${INCLUDE_DIRECTORIES_BACKUP})
set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${SHARED_LINKER_FLAGS_DEBUG_BACKUP}")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${SHARED_LINKER_FLAGS_RELEASE_BACKUP}")