
macro(configure_avr_properties)
    if(AVR_MCU AND AVR_CLOCK)
        if(AVR_MCU_CURRENT)
            remove_c_flag(  -mmcu=${AVR_MCU_CURRENT})
            remove_cxx_flag(-mmcu=${AVR_MCU_CURRENT})
        endif()
        if(AVR_CLOCK_CURRENT)
            remove_c_flag(  -DF_CPU=${AVR_CLOCK_CURRENT})
            remove_cxx_flag(-DF_CPU=${AVR_CLOCK_CURRENT})
        endif()
        add_c_flags(  -mmcu=${AVR_MCU} -DF_CPU=${AVR_CLOCK})
        add_cxx_flags(-mmcu=${AVR_MCU} -DF_CPU=${AVR_CLOCK})
        set(AVR_MCU_CURRENT   ${AVR_MCU} CACHE INTERNAL "")
        set(AVR_CLOCK_CURRENT ${AVR_CLOCK} CACHE INTERNAL "")
    else()
        error("You must define the mcu type and its clock frequency.")
    endif()
endmacro()

# ==============================================================================

macro(set_avr_output_files target)
    set(${target}_ELF       "${CMAKE_CURRENT_BINARY_DIR}/${target}.elf")
    set(${target}_HEX       "${CMAKE_CURRENT_BINARY_DIR}/${target}-${AVR_MCU}.hex")
    set(${target}_MAP       "${CMAKE_CURRENT_BINARY_DIR}/${target}-${AVR_MCU}.map")
    set(${target}_DISASM    "${CMAKE_CURRENT_BINARY_DIR}/${target}-${AVR_MCU}.disasm.s")
endmacro()

# ------------------------------------------------------------------------------

macro(add_hex_generation_phase target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${AVR_BINUTILS_DIR}/avr-objcopy -j .text -j .data -O ihex ${${target}_ELF} ${${target}_HEX}
        COMMAND ${AVR_BINUTILS_DIR}/avr-objdump -S -seglCGD ${${target}_ELF} > ${${target}_DISASM}
        COMMAND ${AVR_BINUTILS_DIR}/avr-size ${${target}_ELF} -C --mcu=${AVR_MCU}
    )
endmacro()

# ------------------------------------------------------------------------------

macro(add_upload_target target)
    set(port)
    if(${TARGET_AVR_AVRDUDE_PORT})
        set(port "-P ${TARGET_AVR_AVRDUDE_PORT}")
    endif()

    # Using full absolute path crashes avrdude on Windows
    get_filename_component(dir "${${target}_HEX}" PATH)
    get_filename_component(hex "${${target}_HEX}" NAME)

    avr_get_avrdude_mcu_id(avrdude_mcu)
    add_custom_target(${target}-upload
        COMMAND     avrdude
                    -c ${AVRDUDE_PROGRAMMER}
                    -p ${avrdude_mcu}
                    -B 1 # See http://www.ladyada.net/make/usbtinyisp/avrdude.html
                    ${port}
                    -U flash:w:${hex}
        WORKING_DIRECTORY ${dir}
        DEPENDS     ${target}
        DEPENDS     ${${target}_HEX}
        COMMENT     "Uploading ${${target}_HEX} to ${AVR_MCU} using programmer ${AVRDUDE_PROGRAMMER}"
    )
endmacro()

# ==============================================================================

macro(configure_avr_flags)
    configure_avr_properties()
    add_c_cxx_flag(-DTARGET_AVR=1)
    add_c_flags(-fpack-struct -fshort-enums -funsigned-bitfields -funsigned-char)
    add_cxx_flags(-fno-exceptions)
    add_c_cxx_flags(-ffunction-sections -fdata-sections)
    add_linker_exe_flag("-Wl,-relax,-gc-sections")
endmacro()

# ------------------------------------------------------------------------------

macro(target_avr_configure_flags target)

    file(MAKE_DIRECTORY "${${target}_BINARY_DIR}/disasm")
    foreach(src ${${target}_SOURCES})
        get_filename_component(srcName "${src}" NAME_WE)
        get_filename_component(srcExt  "${src}" EXT)
        set_source_files_properties(${src} PROPERTIES
            COMPILE_FLAGS "-Wa,-adhlms=${${target}_BINARY_DIR}/disasm/${srcName}.lst"
        )
        if(srcExt STREQUAL ".cpp")
            # Demangle C++ names
            add_custom_command(TARGET ${target}
                POST_BUILD
                COMMAND cat "${${target}_BINARY_DIR}/disasm/${srcName}.lst" | c++filt -n > "${${target}_BINARY_DIR}/disasm/${srcName}.lst"
            )
        endif()
    endforeach()

    foreach(config ${BUILDER_CONFIGURATIONS})
        string(TOUPPER ${config} config)
        set_target_properties(${target} PROPERTIES
            LINK_FLAGS_${config} "-Wl,--cref,-Map,${${target}_MAP}"
        )
    endforeach()

    set_target_properties(${target} PROPERTIES
        LINK_FLAGS "-Wl,--cref,-Map,${${target}_MAP}"
    )
endmacro()

# ------------------------------------------------------------------------------

macro(configure_avr_specifics)
    configure_avr_flags()
endmacro()

# ------------------------------------------------------------------------------

macro(avr_get_avrdude_mcu_id output)
    if(AVR_MCU)
        if(${AVR_MCU}       STREQUAL "attiny84")
            set(${output} "t84")
        elseif(${AVR_MCU}   STREQUAL "atmega644p")
            set(${output} "m644p")
        elseif(${AVR_MCU}   STREQUAL "atmega168")
            set(${output} "m168")
        elseif(${AVR_MCU}   STREQUAL "atmega328p")
            set(${output} "m328p")
        elseif(${AVR_MCU}    STREQUAL "atmega32u4")
            set(${output} "m32u4")
        else()
            todo("Implement this part's id for avrdude.")
        endif()
    else()
        error("Please define the MCU to use.")
    endif()
endmacro()

# ------------------------------------------------------------------------------

macro(add_avr_subdirectory name mcu)
    list(APPEND mcus ${mcu})
    foreach(m ${mcus})
        if(${AVR_MCU} STREQUAL ${m})
            add_subdirectory(${name})
            break()
        endif()
    endforeach()
    unset(mcus)
endmacro()
