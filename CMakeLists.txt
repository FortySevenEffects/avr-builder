set(CMAKE_TOOLCHAIN_FILE "platform/avr/toolchain.cmake")
set(ROOT_SOURCE_DIR ${PROJECT_SOURCE_DIR} CACHE INTERNAL "Repository root directory")
set(ROOT_BINARY_DIR "${ROOT_SOURCE_DIR}/build")
set(BUILDER_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "Builder source directory")

macro(setup_builder)
    enable_testing()

    include_directories(${ROOT_SOURCE_DIR})

    add_cxx_flags(
    	-W
    	-Wall 
    	-Wshadow
    	-Wunused -Wunused-variable -Wunused-function -Wno-unused-parameter
    	-Wno-system-headers
    	-Wno-deprecated
    	-Woverloaded-virtual
    )
    add_cxx_flag(-std=c++11)

endmacro()

# --

include(macros/flags.cmake)
include(macros/strings.cmake)
include(namespace.cmake)
include(target.cmake)

# --

set(TARGET_AVR TRUE)
include(platform/avr/properties.cmake)
include(platform/avr/builder/avr-atmega644p-16mhz.cmake)


configure_avr_specifics()
