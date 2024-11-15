# Based on swift-embedded-examples/pico-blinky-sdk/CMakeLists.txt

cmake_minimum_required(VERSION 3.13)

if(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build type" FORCE)
    set(PICO_DEOPTIMIZED_DEBUG 1)
endif()
# CMake will find the SDK and set PICO_SDK_PATH
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(d-blinky)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT DEFINED PICO_SDK_PATH)
    message(FATAL_ERROR "PICO_SDK_PATH is not defined. Please set it to the path of the Pico SDK.")
    return()
endif()

option(BETTERC "Enable BetterC mode" OFF)

set(D_FLAGS "")

if(DEFINED ENV{DC})
    set(DC $ENV{DC})
else()
    message(FATAL_ERROR "DC is not defined. Please set it to the path of the D compiler.")
endif()

pico_sdk_init()


if(PICO_PLATFORM STREQUAL "rp2350-arm-s")
    message(STATUS "PICO_PLATFORM is set to rp2350-arm-s, using armv7em")
    set(D_TARGET "arm-unknown-unknown-eabi")
    set(D_CPU "cortex-m33")
elseif(PICO_PLATFORM STREQUAL "rp2040")
    message(STATUS "PICO_PLATFORM is set to RP2040, using armv6m")
    set(D_TARGET "arm-unknown-unknown-eabi")
    set(D_CPU "cortex-m0plus")
    set(APPEND D_FLAGS "--d-version=RP2040")
elseif(PICO_PLATFORM STREQUAL "rp2350-riscv")
    message(STATUS "PICO_PLATFORM is set to rp2350-riscv, using riscv32.")
    set(D_TARGET "riscv32-unknown-unknown-eabi")
    set(D_CPU "generic-rv32")
endif()

if(DC MATCHES ".*ldc2$")
    list(APPEND D_FLAGS "-preview=all")
    list(APPEND D_FLAGS "-Xcc=-fshort-enums")
    list(APPEND D_FLAGS "--verrors-context")
    list(APPEND D_FLAGS "--boundscheck=on")
    list(APPEND D_FLAGS "--allinst")
    list(APPEND D_FLAGS "--linkonce-templates")
    list(APPEND D_FLAGS "-mtriple=${D_TARGET}")
    list(APPEND D_FLAGS "-mcpu=${D_CPU}")

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        list(APPEND D_FLAGS "-g")
        list(APPEND D_FLAGS "--gc")
        list(APPEND D_FLAGS "-d-debug")
    else()
        list(APPEND D_FLAGS "-O")
    endif()
    if(BETTERC)
        list(APPEND D_FLAGS "-betterC")
    else()
        list(APPEND D_FLAGS "--fno-moduleinfo")
    endif()
    if(PICO_PLATFORM STREQUAL "rp2350-riscv")
        list(APPEND D_FLAGS "-mattr=+i,+m,+a,+c,+zicsr,+zifencei,+zba,+zbb,+zbs,+zbkb" "-mabi=ilp32")
    else()
        list(APPEND D_FLAGS "--float-abi=soft")
    endif()

    list(APPEND D_FLAGS "-of=${CMAKE_CURRENT_BINARY_DIR}/_dcode.o")
elseif(DC MATCHES ".*gdc$")
    list(APPEND D_FLAGS "-fpreview=all")
    list(APPEND D_FLAGS "-fbounds-check")
    list(APPEND D_FLAGS "-fall-instantiations")
    list(APPEND D_FLAGS "-fshort-enums")

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        list(APPEND D_FLAGS "-Og")
        list(APPEND D_FLAGS "-fdebug")
    else()
        list(APPEND D_FLAGS "-O3")
    endif()
    if(BETTERC)
        list(APPEND D_FLAGS "-fno-druntime")
    else()
        list(APPEND D_FLAGS "-fno-moduleinfo")
    endif()
    if(PICO_PLATFORM STREQUAL "rp2350-riscv")
        list(APPEND D_FLAGS "-march=rv32imac_zicsr_zifencei_zba_zbb_zbs_zbkb")
        list(APPEND D_FLAGS "-mabi=ilp32")
    else()
        list(APPEND D_FLAGS "-marm")
        list(APPEND D_FLAGS "-mfloat-abi=soft")
        if(PICO_PLATFORM STREQUAL "rp2040")
            list(APPEND D_FLAGS "-march=armv6-m")
        else()
            list(APPEND D_FLAGS "-march=armv7e-m")
        endif()
        list(APPEND D_FLAGS "-mcpu=${D_CPU}")
    endif()

    list(APPEND D_FLAGS "-o")
    list(APPEND D_FLAGS "${CMAKE_CURRENT_BINARY_DIR}/_dcode.o")
elseif(DC MATCHES ".*dmd$")
    message(FATAL_ERROR "DMD does not support rp2040.")
else()
    message(FATAL_ERROR "Unknown D compiler: ${DC}")
endif()

add_executable(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME}
    pico_stdlib hardware_uart hardware_gpio
)

# Gather compile definitions from all dependencies

set_property(GLOBAL PROPERTY visited_targets "")
set_property(GLOBAL PROPERTY compilerdefs_list "")

function(gather_compile_definitions_recursive target)
    # Get the current value of visited_targets
    get_property(visited_targets GLOBAL PROPERTY visited_targets)

    # make sure we don't visit the same target twice
    # and that we don't visit the special generator expressions
    if(${target} MATCHES "\\$<" OR ${target} MATCHES "::@" OR ${target} IN_LIST visited_targets)
        return()
    endif()

    # Append the target to visited_targets
    list(APPEND visited_targets ${target})
    set_property(GLOBAL PROPERTY visited_targets "${visited_targets}")

    # Get the current value of compilerdefs_list
    get_property(compilerdefs_list GLOBAL PROPERTY compilerdefs_list)

    get_target_property(target_definitions ${target} INTERFACE_COMPILE_DEFINITIONS)
    if(target_definitions)
        # Append the target definitions to compilerdefs_list
        list(APPEND compilerdefs_list ${target_definitions})
        set_property(GLOBAL PROPERTY compilerdefs_list "${compilerdefs_list}")
    endif()

    get_target_property(target_linked_libs ${target} INTERFACE_LINK_LIBRARIES)
    if(target_linked_libs)
        foreach(linked_target ${target_linked_libs})
            # Recursively gather compile definitions from dependencies
            gather_compile_definitions_recursive(${linked_target})
        endforeach()
    endif()
endfunction()

gather_compile_definitions_recursive(${PROJECT_NAME})
get_property(COMPILE_DEFINITIONS GLOBAL PROPERTY compilerdefs_list)

# Parse compiler definitions into a format that ldc can understand
list(REMOVE_DUPLICATES COMPILE_DEFINITIONS)
list(PREPEND COMPILE_DEFINITIONS "")
string(REPLACE "$<TARGET_PROPERTY:PICO_TARGET_BINARY_TYPE>" "$<TARGET_PROPERTY:${PROJECT_NAME},PICO_TARGET_BINARY_TYPE>" COMPILE_DEFINITIONS "${COMPILE_DEFINITIONS}")
string(REPLACE ";" ";-Xcc=-D" COMPILE_DEFINITIONS "${COMPILE_DEFINITIONS}")

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/_dcode.o
    COMMAND
    ${DC}
    -i -c
    ${D_FLAGS}
    ${COMPILE_DEFINITIONS}
    ${CLANG_ARCH_ABI_FLAGS}
    $$\( echo '$<TARGET_PROPERTY:${PROJECT_NAME},INCLUDE_DIRECTORIES>' | tr '\;' '\\n' | sed -e 's/\\\(.*\\\)/-P-I\\1/g' \)
    $$\( echo '${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}' | tr ' ' '\\n' | sed -e 's/\\\(.*\\\)/-P-I\\1/g' \)
    ${CMAKE_CURRENT_LIST_DIR}/sample/app.d
    -I${CMAKE_CURRENT_LIST_DIR}/source
    DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/sample/app.d
)
add_custom_target(${PROJECT_NAME}-dcode DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/_dcode.o)


target_link_libraries(${PROJECT_NAME}
    ${CMAKE_CURRENT_BINARY_DIR}/_dcode.o
)
add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}-dcode)
pico_add_extra_outputs(${PROJECT_NAME})
