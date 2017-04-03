macro(target t)
    project(${t} CXX)

    set(${t}_INCLUDE_DIRS)
    set(${t}_PRIVATE_INCLUDE_DIRS)
    set(${t}_SOURCES)
    set(${t}_DEFS)
    set(${t}_PRIVATE_DEFS)
    set(${t}_DEPS)
    set(${t}_PRIVATE_DEPS)
endmacro()

# --

macro(target_begin target)
    generate_namespace_file(${target})
    list(INSERT ${target}_INCLUDE_DIRS 0
        ${${target}_SOURCE_DIR}
        ${${target}_BINARY_DIR}
    )
endmacro()

macro(target_end target)
    target_include_directories(${target} PUBLIC      "${${target}_INCLUDE_DIRS}")
    target_include_directories(${target} INTERFACE   "${${target}_INTERFACE_INCLUDE_DIRS}")
    target_include_directories(${target} PRIVATE     "${${target}_PRIVATE_INCLUDE_DIRS}")
    target_compile_definitions(${target} PUBLIC      "${${target}_DEFS}")
    target_compile_definitions(${target} INTERFACE   "${${target}_INTERFACE_DEFS}")
    target_compile_definitions(${target} PRIVATE     "${${target}_PRIVATE_DEFS}")
    target_link_libraries(${target}      PUBLIC      "${${target}_DEPS}")
    target_link_libraries(${target}      INTERFACE   "${${target}_INTERFACE_DEPS}")
    target_link_libraries(${target}      PRIVATE     "${${target}_PRIVATE_DEPS}")
endmacro()

# --


macro(target_include_dirs target)
    list(APPEND ${target}_INCLUDE_DIRS ${ARGN})
endmacro()

# --

macro(target_private_include_dirs target)
    list(APPEND ${target}_PRIVATE_INCLUDE_DIRS ${ARGN})
endmacro()

# --

macro(target_sources target)
    list(APPEND ${target}_SOURCES ${ARGN})
endmacro()

# --

macro(target_defs target)
    list(APPEND ${target}_DEFS ${ARGN})
endmacro()

# --

macro(target_private_defs target)
    list(APPEND ${target}_PRIVATE_DEFS ${ARGN})
endmacro()

# --

macro(target_deps target)
    list(APPEND ${target}_DEPS ${ARGN})
endmacro()

# --

macro(target_private_deps target)
    list(APPEND ${target}_PRIVATE_DEPS ${ARGN})
endmacro()


# --

macro(build_static_library target)
    target_begin(${target})
    add_library(${target} STATIC ${${target}_SOURCES})
    target_end(${target})
endmacro()

macro(build_avr_firmware target)
    target_begin(${target})
    set_avr_output_files(${target})
    add_executable(${target} ${${target}_SOURCES})
    set_target_properties(${target} PROPERTIES SUFFIX ".elf")
    add_hex_generation_phase(${target})
    add_upload_target(${target})
    target_end(${target})
endmacro()
