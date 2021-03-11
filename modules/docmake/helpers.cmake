cmake_minimum_required(VERSION 3.10)

function(helper_prepare_file_paths)
    set(oneValueArgs INPUT_FILE INPUT_ROOT_PATH INPUT_DEST_PATH OUTPUT_ABSOLUTE_SOURCE_FILE OUTPUT_RELATIVE_FILE OUTPUT_ABSOLUTE_DEST_FILE OUTPUT_ABSOLUTE_DEST_FOLDER)
    cmake_parse_arguments(HELPER "" "${oneValueArgs}" "" ${ARGN})

    get_filename_component(absolute_file_path ${HELPER_INPUT_FILE} ABSOLUTE)
    get_filename_component(destination_parent_folder ${HELPER_INPUT_DEST_PATH} ABSOLUTE)
    file(RELATIVE_PATH relative_file_path ${HELPER_INPUT_ROOT_PATH} ${absolute_file_path})
    get_filename_component(relative_file_folder ${relative_file_path} DIRECTORY)
    set(destination_file ${destination_parent_folder}/${relative_file_path})
    set(destination_folder ${destination_parent_folder}/${relative_file_folder})

    # prepare destination folder
    file(MAKE_DIRECTORY ${destination_folder})

    set(${HELPER_OUTPUT_ABSOLUTE_SOURCE_FILE} ${absolute_file_path} PARENT_SCOPE)
    set(${HELPER_OUTPUT_RELATIVE_FILE} ${relative_file_path} PARENT_SCOPE)
    set(${HELPER_OUTPUT_ABSOLUTE_DEST_FILE} ${destination_file} PARENT_SCOPE)
    set(${HELPER_OUTPUT_ABSOLUTE_DEST_FOLDER} ${destination_folder} PARENT_SCOPE)
endfunction()


function(helper_replace_file_extension INPUT EXTENSION OUTPUT)
    get_filename_component(folder ${INPUT} DIRECTORY)
    get_filename_component(file_name ${INPUT} NAME_WE)
    set(output ${folder}/${file_name}.${extension})

    set(${OUTPUT} ${output} PARENT_SCOPE)
endfunction()


function(prepare_tool NAME OUT_VAR)
    if(NOT EXISTS ${${OUT_VAR}})
        find_program(${OUT_VAR} NAMES ${NAME})
        mark_as_advanced(${OUT_VAR})
        if(NOT EXISTS ${${OUT_VAR}})
            message(FATAL_ERROR "${NAME} not found")
            return()
        endif()
        execute_process(
                COMMAND ${${OUT_VAR}} --version
                OUTPUT_VARIABLE version
                ERROR_VARIABLE version)
        string(REGEX REPLACE "\n" ";" version ${version})
        list(GET version 0 version)
        message(STATUS "Using ${NAME}: ${version}")
        unset(version)
    endif()
endfunction()
