macro(generate_namespace_file target)

    to_namespace_def(NAMESPACE_DEF  ${target})
    to_namespace(namespace ${target})

    set(template "${BUILDER_SOURCE_DIR}/templates/namespace.h.in")

    configure_file(${template} "./${target}_Namespace.h" @ONLY)

    unset(NAMESPACE_DEF)
    unset(namespace)
    unset(template)
endmacro()
