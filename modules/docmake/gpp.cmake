cmake_minimum_required(VERSION 3.10)

include(docmake/helpers)

prepare_tool(gpp GPP_EXECUTABLE)

set(GPP_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR})


function(gpp_preprocessor)
    set(oneValueArgs OUTPUT_LIST)
    set(multiValueArgs SOURCES DEFINES INCLUDE_PATHS)
    cmake_parse_arguments("GPP_PREPROCESSOR" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(define_argument_list)
    foreach(define ${GPP_PREPROCESSOR_DEFINES})
        set(define_argument_list "${define_argument_list} -D${define}")
    endforeach()

    set(include_path_list)
    set(include_files_list)
    foreach(include_path ${GPP_PREPROCESSOR_INCLUDE_PATHS})
        get_filename_component(absolute_include_path ${include_path} ABSOLUTE)
        set(include_path_list "${include_path_list} -I${absolute_include_path}")

        file(GLOB_RECURSE include_files ${absolute_include_path}/*)
        list(APPEND include_files_list ${include_files})
    endforeach()

    set(destination_folder ${CMAKE_CURRENT_BINARY_DIR}/gpp_preprocessor_${GPP_PREPROCESSOR_OUTPUT_LIST})

    set(output_list)
    foreach(source ${GPP_PREPROCESSOR_SOURCES})
        helper_prepare_file_paths(
                INPUT_FILE ${source}
                INPUT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}
                INPUT_DEST_PATH ${destination_folder}
                OUTPUT_ABSOLUTE_SOURCE_FILE absolute_source
                OUTPUT_RELATIVE_FILE relative_file
                OUTPUT_ABSOLUTE_DEST_FILE absolute_dest_file
                OUTPUT_ABSOLUTE_DEST_FOLDER absolute_dest_folder
        )

        add_custom_command(
                OUTPUT ${absolute_dest_file}
                COMMAND ${GPP_CMAKE_DIR}/gpp.sh
                ${define_argument_list}
                --nostdinc
                ${include_path_list}
                ${absolute_source} -o ${absolute_dest_file}
                DEPENDS ${absolute_source} ${include_files_list}
                COMMENT "Preprocessing (${define_argument_list}): ${relative_file}"
                VERBATIM
        )

        list(APPEND output_list ${absolute_dest_file})
    endforeach()

    set(${GPP_PREPROCESSOR_OUTPUT_LIST} ${output_list} PARENT_SCOPE)
endfunction()
