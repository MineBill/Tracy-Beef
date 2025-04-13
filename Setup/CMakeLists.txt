cmake_minimum_required(VERSION 3.20)
project("Tracy-Native")

include(BeefLibProjectHelper/Helper.cmake)
include(FetchContent)

SetOption(TRACY_ON_DEMAND ON)
SetOption(TRACY_CALLSTACK ON)

FetchContent_Declare(
    tracy
    GIT_REPOSITORY https://github.com/wolfpld/tracy
    GIT_TAG v0.11.1
)
FetchContent_MakeAvailable(tracy)

add_custom_target(BuildLibsTarget
    DEPENDS TracyClient
    COMMENT "Building tracy"
)

CopyLibrary(TracyClient "../dist")
