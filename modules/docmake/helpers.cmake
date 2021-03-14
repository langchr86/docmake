cmake_minimum_required(VERSION 3.10)


#! helper_prepare_file_paths : Helps to create file paths in the build folder
#
# This is most used for add_custom_command that have to prepare some output folder and
# the corresponding output files. It does evaluate the folder structure in the
# input file paths and recreates this exact structure in the output paths.
#
# Most input file paths can be absolute or relative if not explicitly described.
# OUTPUT_* variables are output parameters that defined the variable name that will be set by this function.
#
# \param:INPUT_FILE Path of the file that works as input of the compilation step.
# \param:INPUT_ROOT_PATH Most of the cases an absolute path of the root of the to replicated file structure.
# \param:INPUT_DEST_PATH Path to the root folder where the structure is replicated and the destination file is then placed.
# \param:OUTPUT_ABSOLUTE_SOURCE_FILE Absolute path to the source file.
# \param:OUTPUT_RELATIVE_FILE Relative path of both files to their respective root folder (is equal by design).
# \param:OUTPUT_ABSOLUTE_DEST_FILE Absolute path to the destination file.
# \param:OUTPUT_ABSOLUTE_DEST_FOLDER Absolute path to the lowest level of the output directory structure. The output file is generated in this folder.
#
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


#! helper_replace_file_extension : Helps to replace the file extension in a file path
#
# \arg:INPUT A file path.
# \arg:EXTENSION The new extension that should be replace the current one of the INPUT file.
# \arg:OUTPUT Output parameter that will be set to the similar path as provided by INPUT but with the new extension.
#
function(helper_replace_file_extension INPUT EXTENSION OUTPUT)
    get_filename_component(folder ${INPUT} DIRECTORY)
    get_filename_component(file_name ${INPUT} NAME_WE)
    set(output ${folder}/${file_name}.${extension})

    set(${OUTPUT} ${output} PARENT_SCOPE)
endfunction()


#! prepare_tool : Helps to find a CLI executable that is used e.g. in add_custom_command
#
# \arg:NAME Name of a CLI application that can be called with --version.
# \arg:OUT_VAR Output parameter that will be set to the correct path to the executable. This one should then be used in add_custom_command.
#
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
