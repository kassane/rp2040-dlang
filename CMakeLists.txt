# Based on swift-embedded-examples/pico-blinky-sdk/CMakeLists.txt

cmake_minimum_required(VERSION 3.13)
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(d-blinky)

# CMake will find the SDK and set PICO_SDK_PATH
pico_sdk_init()

execute_process(COMMAND which ldc2 OUTPUT_VARIABLE DC OUTPUT_STRIP_TRAILING_WHITESPACE)

if(PICO_PLATFORM STREQUAL "rp2350-arm-s")
    message(STATUS "PICO_PLATFORM is set to rp2350-arm-s, using armv7em")
    set(D_TARGET "arm-unknown-unknown-eabi")
    set(D_CPU "cortex-m0plus")
    list(APPEND CLANG_ARCH_ABI_FLAGS "--float-abi=soft")
elseif(PICO_PLATFORM STREQUAL "rp2040")
    message(STATUS "PICO_PLATFORM is set to RP2040, using armv6m")
    set(D_TARGET "arm-unknown-unknown-eabi")
    set(D_CPU "cortex-m0")
    list(APPEND CLANG_ARCH_ABI_FLAGS "--float-abi=soft")
elseif(PICO_PLATFORM STREQUAL "rp2350-riscv")
    message(STATUS "PICO_PLATFORM is set to rp2350-riscv, using riscv32.")
    set(D_TARGET "riscv32-unknown-unknown-eabi")
    set(D_CPU "generic-rv32")
    list(APPEND CLANG_ARCH_ABI_FLAGS "-mattr=+m,+a,+c,+zicsr,+zifencei,+zba,+zbb,+zbs,+zbkb" "-mabi=ilp32")
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
    -i --verrors-context -preview=all
    -mtriple=${D_TARGET} -mcpu=${D_CPU} -Xcc=-fshort-enums
    ${COMPILE_DEFINITIONS}
    ${CLANG_ARCH_ABI_FLAGS}
    $$\( echo '$<TARGET_PROPERTY:${PROJECT_NAME},INCLUDE_DIRECTORIES>' | tr '\;' '\\n' | sed -e 's/\\\(.*\\\)/-P-I\\1/g' \)
    $$\( echo '${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}' | tr ' ' '\\n' | sed -e 's/\\\(.*\\\)/-P-I\\1/g' \)
    ${CMAKE_CURRENT_LIST_DIR}/source/app.d
    -betterC -O -I${CMAKE_CURRENT_LIST_DIR}/source
    -c -of=${CMAKE_CURRENT_BINARY_DIR}/_dcode.o
    DEPENDS
    ${CMAKE_CURRENT_LIST_DIR}/source/app.d
)
add_custom_target(${PROJECT_NAME}-dcode DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/_dcode.o)


target_link_libraries(${PROJECT_NAME}
    ${CMAKE_CURRENT_BINARY_DIR}/_dcode.o
)
add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}-dcode)
pico_add_extra_outputs(${PROJECT_NAME})
