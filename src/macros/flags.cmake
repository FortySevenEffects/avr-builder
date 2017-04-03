macro(change_flag var_name from_flag to_flag)
    string(REPLACE ${from_flag} ${to_flag} tmp ${${var_name}})
    set(${var_name} ${tmp} CACHE STRING "" FORCE)
endmacro()

# ------------------------------------------------------------------------------

macro(has_flag var flag result)
    string(REPLACE "-" "\\-" flagSafe ${flag})
    string(REPLACE "+" "\\+" flagSafe ${flagSafe})
    string(REPLACE "." "\\." flagSafe ${flagSafe})
    string(REPLACE "*" "\\*" flagSafe ${flagSafe})
    string(REGEX MATCH "${flagSafe}" flag_found "${${var}}")
    if(flag_found)
        set(${result} TRUE)
    else()
        set(${result} FALSE)
    endif()
    unset(flag_found)
    unset(flagSafe)
endmacro()

# ------------------------------------------------------------------------------

macro(add_flag var flag)
    has_flag(${var} ${flag} found)
    if(NOT found)
        if(${var})
            set(${var} "${${var}} ${flag}" CACHE STRING "" FORCE)
        else()
            set(${var} "${flag}" CACHE STRING "" FORCE)
        endif()
    endif()
    unset(found)
endmacro()

# ------------------------------------------------------------------------------

macro(add_flags var)
    foreach(flag ${ARGN})
        add_flag(${var} ${flag})
    endforeach()
endmacro()

# ------------------------------------------------------------------------------

macro(remove_flag var flag)
    string(REPLACE ${flag} "" tmp ${${var}})
    set(${var} ${tmp} CACHE STRING "" FORCE)
endmacro()

# ------------------------------------------------------------------------------

macro(remove_flags var)
    foreach(flag ${ARGN})
        remove_flag(${var} ${flag})
    endforeach()
endmacro()

################################################################################

macro(add_c_flag_config config flag)
    string(TOUPPER ${config} conf)
    add_flag(CMAKE_C_FLAGS_${conf} ${flag})
endmacro()

macro(add_c_flags_config config)
    string(TOUPPER ${config} conf)
    add_flags(CMAKE_C_FLAGS_${conf} ${ARGN})
endmacro()

macro(add_c_flag flag)
    add_flag(CMAKE_C_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_c_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(add_c_flags)
    add_flags(CMAKE_C_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_c_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

# ------------------------------------------------------------------------------

macro(add_cxx_flag_config config flag)
    string(TOUPPER ${config} conf)
    add_flag(CMAKE_CXX_FLAGS_${conf} ${flag})
endmacro()

macro(add_cxx_flags_config config)
    string(TOUPPER ${config} conf)
    add_flags(CMAKE_CXX_FLAGS_${conf} ${ARGN})
endmacro()

macro(add_cxx_flag flag)
    add_flag(CMAKE_CXX_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_cxx_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(add_cxx_flags)
    add_flags(CMAKE_CXX_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_cxx_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

# ------------------------------------------------------------------------------

macro(add_c_cxx_flag_config config flag)
    add_c_flag_config(${config} ${flag})
    add_cxx_flag_config(${config} ${flag})
endmacro()

macro(add_c_cxx_flags_config config)
    add_c_flags_config(${config} ${ARGN})
    add_cxx_flags_config(${config} ${ARGN})
endmacro()

macro(add_c_cxx_flag flag)
    add_c_flag(${flag})
    add_cxx_flag(${flag})
endmacro()

macro(add_c_cxx_flags)
    add_c_flags(${ARGN})
    add_cxx_flags(${ARGN})
endmacro()

# ------------------------------------------------------------------------------

macro(add_linker_module_flag_config config flag)
    string(TOUPPER ${config} conf)    
    add_flag(CMAKE_MODULE_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(add_linker_exe_flag_config config flag)
    string(TOUPPER ${config} conf)
    add_flag(CMAKE_EXE_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(add_linker_shared_flag_config config flag)
    string(TOUPPER ${config} conf)
    add_flag(CMAKE_SHARED_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(add_linker_module_flag flag)
    add_flag(CMAKE_MODULE_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_module_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(add_linker_exe_flag flag)
    add_flag(CMAKE_EXE_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_exe_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(add_linker_shared_flag flag)
    add_flag(CMAKE_SHARED_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_shared_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(add_linker_flag flag)
    add_linker_module_flag(${flag})
    add_linker_exe_flag(${flag})
    add_linker_shared_flag(${flag})
endmacro()

# ------------------------------------------------------------------------------

macro(add_linker_module_flags_config config)
    string(TOUPPER ${config} conf)    
    add_flags(CMAKE_MODULE_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(add_linker_exe_flags_config config)
    string(TOUPPER ${config} conf)
    add_flags(CMAKE_EXE_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(add_linker_shared_flags_config config)
    string(TOUPPER ${config} conf)
    add_flags(CMAKE_SHARED_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(add_linker_module_flags)
    add_flags(CMAKE_MODULE_LINKER_FLAGS ${ARNG})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_module_flags_config(${config} ${ARNG})
    endforeach()
endmacro()

macro(add_linker_exe_flags)
    add_flags(CMAKE_EXE_LINKER_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_exe_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

macro(add_linker_shared_flags)
    add_flags(CMAKE_SHARED_LINKER_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        add_linker_shared_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

macro(add_linker_flags)
    add_linker_module_flags(${ARGN})
    add_linker_exe_flags(${ARGN})
    add_linker_shared_flags(${ARGN})
endmacro()

################################################################################

macro(remove_c_flag_config config flag)
    string(TOUPPER ${config} conf)
    remove_flag(CMAKE_C_FLAGS_${conf} ${flag})
endmacro()

macro(remove_c_flags_config config)
    string(TOUPPER ${config} conf)
    remove_flags(CMAKE_C_FLAGS_${conf} ${ARGN})
endmacro()

macro(remove_c_flag flag)
    remove_flag(CMAKE_C_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_c_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(remove_c_flags)
    remove_flags(CMAKE_C_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_c_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

# ------------------------------------------------------------------------------

macro(remove_cxx_flag_config config flag)
    string(TOUPPER ${config} conf)
    remove_flag(CMAKE_CXX_FLAGS_${conf} ${flag})
endmacro()

macro(remove_cxx_flags_config config)
    string(TOUPPER ${config} conf)
    remove_flags(CMAKE_CXX_FLAGS_${conf} ${ARGN})
endmacro()

macro(remove_cxx_flag flag)
    remove_flag(CMAKE_CXX_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_cxx_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(remove_cxx_flags)
    remove_flags(CMAKE_CXX_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_cxx_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

# ------------------------------------------------------------------------------

macro(remove_c_cxx_flag_config config flag)
    remove_c_flag_config(${config} ${flag})
    remove_cxx_flag_config(${config} ${flag})
endmacro()

macro(remove_c_cxx_flags_config config)
    remove_c_flags_config(${config} ${ARGN})
    remove_cxx_flags_config(${config} ${ARGN})
endmacro()

macro(remove_c_cxx_flag flag)
    remove_c_flag(${flag})
    remove_cxx_flag(${flag})
endmacro()

macro(remove_c_cxx_flags)
    remove_c_flags(${ARGN})
    remove_cxx_flags(${ARGN})
endmacro()

# ------------------------------------------------------------------------------

macro(remove_linker_module_flag_config config flag)
    string(TOUPPER ${config} conf)    
    remove_flag(CMAKE_MODULE_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(remove_linker_exe_flag_config config flag)
    string(TOUPPER ${config} conf)
    remove_flag(CMAKE_EXE_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(remove_linker_shared_flag_config config flag)
    string(TOUPPER ${config} conf)
    remove_flag(CMAKE_SHARED_LINKER_FLAGS_${conf} ${flag})
endmacro()

macro(remove_linker_module_flag flag)
    remove_flag(CMAKE_MODULE_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_module_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(remove_linker_exe_flag flag)
    remove_flag(CMAKE_EXE_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_exe_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(remove_linker_shared_flag flag)
    remove_flag(CMAKE_SHARED_LINKER_FLAGS ${flag})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_shared_flag_config(${config} ${flag})
    endforeach()
endmacro()

macro(remove_linker_flag flag)
    remove_linker_module_flag(${flag})
    remove_linker_exe_flag(${flag})
    remove_linker_shared_flag(${flag})
endmacro()

# ------------------------------------------------------------------------------

macro(remove_linker_module_flags_config config)
    string(TOUPPER ${config} conf)    
    remove_flags(CMAKE_MODULE_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(remove_linker_exe_flags_config config)
    string(TOUPPER ${config} conf)
    remove_flags(CMAKE_EXE_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(remove_linker_shared_flags_config config)
    string(TOUPPER ${config} conf)
    remove_flags(CMAKE_SHARED_LINKER_FLAGS_${conf} ${ARGN})
endmacro()

macro(remove_linker_module_flags)
    remove_flags(CMAKE_MODULE_LINKER_FLAGS ${ARNG})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_module_flags_config(${config} ${ARNG})
    endforeach()
endmacro()

macro(remove_linker_exe_flags)
    remove_flags(CMAKE_EXE_LINKER_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_exe_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

macro(remove_linker_shared_flags)
    remove_flags(CMAKE_SHARED_LINKER_FLAGS ${ARGN})
    foreach(config ${BUILDER_CONFIGURATIONS})
        remove_linker_shared_flags_config(${config} ${ARGN})
    endforeach()
endmacro()

macro(remove_linker_flags)
    remove_linker_module_flags(${ARGN})
    remove_linker_exe_flags(${ARGN})
    remove_linker_shared_flags(${ARGN})
endmacro()
