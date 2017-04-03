
find_program(AVRGCC_EXECUTABLE
    NAMES "avr-gcc"
    PATHS
        /usr/local/bin
        /usr/bin
        /usr/local/avr/bin
        /usr/avr/bin

    DOC "AVR-GCC - GNU C/C++ cross-compiler for AVR targets"
)

if(AVRGCC_EXECUTABLE)
    execute_process(COMMAND ${AVRGCC_EXECUTABLE} "--version" OUTPUT_VARIABLE AVRGCC_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX MATCH "[0-9]\\.[0-9](\\.[0-9])?" AVRGCC_VERSION ${AVRGCC_VERSION})
    get_filename_component(AVR_BINUTILS_DIR "${AVRGCC_EXECUTABLE}" PATH CACHE)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(avr-gcc REQUIRED_VARS AVRGCC_EXECUTABLE VERSION_VAR AVRGCC_VERSION)

mark_as_advanced(AVRGCC_EXECUTABLE)

set(CMAKE_SYSTEM_NAME "Generic")

include(CMakeForceCompiler)

cmake_force_c_compiler(avr-gcc   "GNU")
cmake_force_cxx_compiler(avr-gcc "GNU")

set(_CMAKE_TOOLCHAIN_PREFIX "avr-")

# ------------------------------------------------------------------------------

set(GCC_VERSION "${AVRGCC_VERSION}" CACHE STRING "")
mark_as_advanced(GCC_VERSION)

string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)?" dummy ${AVRGCC_VERSION})

set(GCC_VERSION_MAJOR   "${CMAKE_MATCH_1}" CACHE STRING "")
set(GCC_VERSION_MINOR   "${CMAKE_MATCH_2}" CACHE STRING "")
set(GCC_VERSION_UPDATE  "${CMAKE_MATCH_3}" CACHE STRING "")
mark_as_advanced(GCC_VERSION_MAJOR)
mark_as_advanced(GCC_VERSION_MINOR)
mark_as_advanced(GCC_VERSION_UPDATE)

# ------------------------------------------------------------------------------

set(TARGET_ARCHITECTURE "AVR"       CACHE STRING "Atmel AVR architecture")
set(TARGET_BITWIDTH     "8"         CACHE STRING "8 bit architecture")
set(TARGET_SYSTEM       "EMBEDDED"  CACHE STRING "Embedded target (no target OS)")
