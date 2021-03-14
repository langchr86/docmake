cmake_minimum_required(VERSION 3.10)

include(docmake/helpers)

prepare_tool(pandoc PANDOC_EXECUTABLE)


function(pandoc_resource_files TARGET ROOT_PATH)
    set(FILES ${ARGN})

    get_target_property(resource_list ${TARGET} RESOURCE_FILES)

    foreach(file ${FILES})
        helper_prepare_file_paths(
                INPUT_FILE ${file}
                INPUT_ROOT_PATH ${ROOT_PATH}
                INPUT_DEST_PATH ${CMAKE_CURRENT_BINARY_DIR}
                OUTPUT_ABSOLUTE_SOURCE_FILE absolute_source
                OUTPUT_RELATIVE_FILE relative_file
                OUTPUT_ABSOLUTE_DEST_FILE absolute_dest_file
                OUTPUT_ABSOLUTE_DEST_FOLDER absolute_dest_folder
        )

        add_custom_command(
                OUTPUT ${absolute_dest_file}
                COMMAND ${CMAKE_COMMAND} -E copy ${absolute_source} ${absolute_dest_folder}
                DEPENDS ${absolute_source}
                COMMENT "Copying pandoc resource file to working dir: ${relative_file}"
                VERBATIM
        )

        list(APPEND resource_list ${absolute_dest_file})
    endforeach()

    set_target_properties(${TARGET} PROPERTIES RESOURCE_FILES "${resource_list}")
endfunction()


function(pandoc_document)
    set(oneValueArgs TARGET TEMPLATE)
    set(multiValueArgs SOURCES HEADERS PARAMS DEPENDS)
    cmake_parse_arguments(PANDOC_DOCUMENT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(output_name ${PANDOC_DOCUMENT_TARGET})
    set(output_path ${CMAKE_CURRENT_BINARY_DIR}/${output_name})

    if(PANDOC_DOCUMENT_TEMPLATE)
        get_filename_component(template_path ${PANDOC_DOCUMENT_TEMPLATE} ABSOLUTE)
        set(template_arg --template=${template_path})
    endif()

    set(source_list)
    foreach(source ${PANDOC_DOCUMENT_SOURCES})
        get_filename_component(source_path ${source} ABSOLUTE)
        list(APPEND source_list ${source_path})
    endforeach()

    set(header_list)
    foreach(header ${PANDOC_DOCUMENT_HEADERS})
        get_filename_component(header_path ${header} ABSOLUTE)
        list(APPEND header_list ${header_path})
        list(APPEND header_arg --include-in-header=${header_path})
    endforeach()

    add_custom_target(
            ${PANDOC_DOCUMENT_TARGET}
            ALL
            DEPENDS ${output_path}
    )

    set_target_properties(${PANDOC_DOCUMENT_TARGET} PROPERTIES RESOURCE_FILES "")

    add_custom_command(
            OUTPUT ${output_path}
            COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}
            ${PANDOC_EXECUTABLE} ${source_list}
            -o ${output_path}
            --fail-if-warnings
            ${header_arg}
            ${template_arg}
            ${PANDOC_DOCUMENT_PARAMS}
            --verbose > ${output_path}.log
            DEPENDS ${source_list} ${header_list} ${template_path}
            DEPENDS $<TARGET_PROPERTY:${PANDOC_DOCUMENT_TARGET},RESOURCE_FILES>
            DEPENDS ${PANDOC_DOCUMENT_DEPENDS}
            COMMENT "Building pandoc document: ${output_name}"
            COMMAND_EXPAND_LISTS
            VERBATIM
    )
endfunction()
