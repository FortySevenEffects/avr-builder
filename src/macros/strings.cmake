macro(to_namespace_def var name)

    set(tmp "${name}")
    string(REGEX REPLACE "([abcdefghijklmnopqrstuvwxyz])([ABCDEFGHIJKLMNOPQRSTUVWXYZ])" "\\1_\\2" tmp "${tmp}")
    string(TOUPPER ${tmp} tmp)
    string(REGEX REPLACE "(/)|(\\.)|(\\\\)|(::)|( )"  "_" tmp "${tmp}")
    string(REGEX REPLACE "^([0123456789])" "_\\1" tmp "${tmp}")
    string(REGEX REPLACE "([^ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_])" "_" tmp "${tmp}")
    set(${var} ${tmp})
    unset(tmp)

endmacro()

# --

macro(to_namespace var name)

    string(TOLOWER "${name}" tmp)
    string(REGEX REPLACE "(/)|(\\.)|(\\\\)|(::)|( )"  "_" tmp "${tmp}")
    string(REGEX REPLACE "^([0123456789])" "_\\1" tmp "${tmp}")
    string(REGEX REPLACE "([^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_])" "_" tmp "${tmp}")
    set(${var} ${tmp})
    unset(tmp)

endmacro()
