cmake_minimum_required(VERSION 3.10)

include(CMakeParseArguments)
include(docmake/helpers)

prepare_tool(drawio DRAWIO_EXECUTABLE)


function(drawio_images)
    set(oneValueArgs OUT_PATH OUT_FILES)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments("DRAWIO_IMAGES" "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(extension pdf)
    set(output_list)

    set(destination_folder ${CMAKE_CURRENT_BINARY_DIR}/drawio_images)

    foreach(source ${DRAWIO_IMAGES_SOURCES})
        helper_prepare_file_paths(
                INPUT_FILE ${source}
                INPUT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}
                INPUT_DEST_PATH ${destination_folder}
                OUTPUT_ABSOLUTE_SOURCE_FILE absolute_source
                OUTPUT_RELATIVE_FILE relative_file_xml
                OUTPUT_ABSOLUTE_DEST_FILE absolute_file_xml
        )

        helper_replace_file_extension(${relative_file_xml} ${extension} relative_dest_file)
        helper_replace_file_extension(${absolute_file_xml} ${extension} absolute_dest_file)

        add_custom_command(
                OUTPUT ${absolute_dest_file}
                COMMAND ${DRAWIO_EXECUTABLE} --export --crop --output=${absolute_dest_file} ${absolute_source}
                DEPENDS ${absolute_source}
                COMMENT "Rendering draw.io image: ${relative_dest_file}"
                VERBATIM
        )

        list(APPEND output_list ${absolute_dest_file})
    endforeach()

    set(${DRAWIO_IMAGES_OUT_PATH} ${destination_folder} PARENT_SCOPE)
    set(${DRAWIO_IMAGES_OUT_FILES} ${output_list} PARENT_SCOPE)
endfunction()
