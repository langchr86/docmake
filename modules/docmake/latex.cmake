cmake_minimum_required(VERSION 3.10)

include(docmake/helpers)

prepare_tool(pdflatex LATEX_EXECUTABLE)
prepare_tool(texfot TEXFOT_EXECUTABLE)


#! latex_files : Compilation of latex files into PDF.
#
# Each input file is processed by pdflatex. To reduce clutter in the output the call is made by texfot.
#
# This calls add_custom_command for each input file. This can process multiple input files at ones.
#
# \param:OUT_PATH Output parameter that will be set to the absolute path where all generated files are placed.
# \param:OUT_FILES Output parameter that will be set to the absolute file paths of all generated files.
# \group:SOURCES Relative or absolute path list of all to convert latex files.
# \group:PARAMS Arbitrary parameters to provide to pdflatex.
#
function(latex_files)
    set(oneValueArgs OUT_PATH OUT_FILES)
    set(multiValueArgs SOURCES PARAMS)
    cmake_parse_arguments("LATEX_FILES" "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(extension pdf)
    set(output_list)

    set(destination_folder ${CMAKE_CURRENT_BINARY_DIR}/latex_files)

    foreach(source ${LATEX_FILES_SOURCES})
        helper_prepare_file_paths(
                INPUT_FILE ${source}
                INPUT_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}
                INPUT_DEST_PATH ${destination_folder}
                OUTPUT_ABSOLUTE_SOURCE_FILE absolute_source
                OUTPUT_RELATIVE_FILE relative_file_name
                OUTPUT_ABSOLUTE_DEST_FILE absolute_dest_name
                OUTPUT_ABSOLUTE_DEST_FOLDER specific_dest_folder
        )

        helper_replace_file_extension(${relative_file_name} ${extension} relative_dest_file)
        helper_replace_file_extension(${absolute_dest_name} ${extension} absolute_dest_file)

        add_custom_command(
                OUTPUT ${absolute_dest_file}
                COMMAND ${CMAKE_COMMAND} -E chdir ${specific_dest_folder}
                ${TEXFOT_EXECUTABLE} --quiet ${LATEX_EXECUTABLE} ${absolute_source}
                ${LATEX_FILES_PARAMS}
                DEPENDS ${absolute_source}
                COMMENT "Building latex file: ${relative_dest_file}"
                VERBATIM
        )

        list(APPEND output_list ${absolute_dest_file})
    endforeach()

    set(${LATEX_FILES_OUT_PATH} ${destination_folder} PARENT_SCOPE)
    set(${LATEX_FILES_OUT_FILES} ${output_list} PARENT_SCOPE)
endfunction()
