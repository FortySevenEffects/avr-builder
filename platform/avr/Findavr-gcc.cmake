# - This module looks for avr-gcc
#
# This modules defines the following variables:
#
#   AVRGCC_EXECUTABLE       = The path to the AVR compiler
#   AVRGCC_FOUND            = Was it found or not?
#   AVRGCC_VERSION          = The version reported by avr-gcc --version
#

find_program(AVRGCC_EXECUTABLE
    NAMES avr-gcc
    PATHS
        /usr/local/bin
        /usr/bin
        /usr/local/avr/bin
        /usr/avr/bin

    DOC "AVR-GCC - GNU C/C++ cross-compiler for AVR targets"
)

if(AVRGCC_EXECUTABLE)
    execute_process(COMMAND ${AVRGCC_EXECUTABLE} "--version" OUTPUT_VARIABLE AVRGCC_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(avr-gcc REQUIRED_VARS AVRGCC_EXECUTABLE VERSION_VAR AVRGCC_VERSION)

mark_as_advanced(AVRGCC_EXECUTABLE)
