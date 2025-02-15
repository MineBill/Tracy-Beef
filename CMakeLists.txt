cmake_minimum_required(VERSION 3.20)
project("Tracy-Native")

set(CMAKE_DEBUG_POSTFIX d)

macro(set_option option value)
  set(${option} ${value} CACHE "" INTERNAL FORCE)
endmacro()

set_option(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
set_option(TRACY_ON_DEMAND ON)
set_option(TRACY_CALLSTACK ON)

include(FetchContent)
FetchContent_Declare(
    tracy
    GIT_REPOSITORY https://github.com/wolfpld/tracy
    GIT_TAG v0.11.1
)
FetchContent_MakeAvailable(tracy)

add_custom_target(build_libs
    DEPENDS TracyClient
    COMMENT "Building tracy"
)

add_custom_target(copy_libs ALL
    COMMENT "Copying library files"
)

function(copy_library target destination)
    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(PLATFORM_SUFFIX "Win64")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(PLATFORM_SUFFIX "Linux64")
    else()
        message(FATAL_ERROR "Unsupported platform: ${CMAKE_SYSTEM_NAME}")
    endif()
    add_custom_command(TARGET copy_libs POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${target}> "${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
    COMMENT "Copying ${target} library to ${CMAKE_SOURCE_DIR}/${destination}/$<CONFIG>-${PLATFORM_SUFFIX}"
)
endfunction()

copy_library(TracyClient "dist")