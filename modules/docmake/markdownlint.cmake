cmake_minimum_required(VERSION 3.10)

include(docmake/helpers)

prepare_tool(markdownlint MDL_EXECUTABLE)


#! setup_markdownlint : Linting markdown files.
#
# Each input file is linted by markdownlint CLI and created a timestamp file. This can be used for dependency creation.
#
# This calls add_custom_command for each input file. This can process multiple input files at ones.
#
# \param:OUTPUT_LIST Output parameter that will be set to the absolute file paths of all generated timestamp files.
# \param:STYLE_FILE Path to the YAML settings file of markdownlint.
# \group:SOURCES Relative or absolute path list of all to lint input files.
#
function(setup_markdownlint)
    set(oneValueArgs OUTPUT_LIST STYLE_FILE)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(MDL "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # define output dir for timestamp files
    set(MDL_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/markdownlint")

    set(output_list)
    foreach (source ${MDL_SOURCES})
        helper_prepare_file_paths(
            INPUT_FILE ${source}
            INPUT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}
            INPUT_DEST_PATH ${MDL_BUILD_DIR}
            OUTPUT_ABSOLUTE_SOURCE_FILE absolute_source
            OUTPUT_ABSOLUTE_DEST_FILE absolute_dest_file
        )

        # define rule to make timestamp files
        add_style_check_rule(${absolute_source} ${absolute_dest_file} ${MDL_STYLE_FILE})
        list(APPEND output_list ${absolute_dest_file})
    endforeach ()

    set(${MDL_OUTPUT_LIST} ${output_list} PARENT_SCOPE)
endfunction()


function(add_style_check_rule SOURCE DEST CONFIG_FILE)
    # prepare subdirectory in markdownlint folder
    get_filename_component(MDL_SUB_FOLDER ${DEST} PATH)
    file(MAKE_DIRECTORY ${MDL_SUB_FOLDER})

    # add custom rule to make markdownlint timestamp file
    add_custom_command(
            OUTPUT "${DEST}"
            COMMAND ${CMAKE_COMMAND} -E chdir
            ${CMAKE_SOURCE_DIR}
            ${MDL_EXECUTABLE}
            --config=${CONFIG_FILE}
            ${SOURCE}
            && ${CMAKE_COMMAND} -E touch ${DEST}
            DEPENDS ${SOURCE}
            DEPENDS ${CONFIG_FILE}
            COMMENT "Linting with markdownlint: ${SOURCE}")
endfunction()