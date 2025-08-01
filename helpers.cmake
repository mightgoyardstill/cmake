# helpers.cmake
include(FetchContent)

# fetch(<name> <url> <tag> [NO_INCLUDE_SCAN])
#
#   name            – short name of the dependency (e.g. fmt, choc)
#   url, tag        – FetchContent arguments
#   NO_INCLUDE_SCAN – optional flag to skip automatic include-path globbing
#
function(fetch name url tag)
    include(FetchContent)

    # --- 1. Bring source into the build tree
    FetchContent_Declare(${name} GIT_REPOSITORY ${url} GIT_TAG ${tag})
    FetchContent_MakeAvailable(${name})

    # --- 2. Reuse an existing target if the project exported one
    set(local_alias "")
    if (TARGET ${name})
        set(local_alias ${name})
    elseif (TARGET ${name}::${name})
        set(local_alias ${name}::${name})
    endif()

    # --- 3. Fallback – create a header-only alias
    if (NOT local_alias)
        add_library(${name}_alias INTERFACE)
        set(local_alias ${name}_alias)
        target_include_directories(${local_alias} INTERFACE
            ${${name}_SOURCE_DIR})
    endif()

    # --- 4. Optional include scan – can be disabled per call
    if (NOT NO_INCLUDE_SCAN AND local_alias STREQUAL "${name}_alias")
        file(GLOB_RECURSE hdrs
             LIST_DIRECTORIES false
             CONFIGURE_DEPENDS
             "${${name}_SOURCE_DIR}/*.h"
             "${${name}_SOURCE_DIR}/*.hpp")
        if (hdrs)
            get_filename_component(root "${${name}_SOURCE_DIR}" ABSOLUTE)
            target_include_directories(${local_alias} INTERFACE "${root}")
        endif()
    endif()
endfunction()

set (platform_libs)
if (APPLE)
 list (APPEND platform_libs
   "-framework WebKit \
   -framework CoreServices \
   -framework CoreAudio \
   -framework CoreMIDI \
   -framework Cocoa \
   -framework CoreFoundation \
   -framework CoreGraphics")
endif (APPLE)
