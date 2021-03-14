include(docmake/pandoc)

function(minimal_script file)
    project(${file} NONE)

    pandoc_document(
            TARGET ${file}.pdf
            SOURCES ${file}.md
            PARAMS -V lang=en-US
    )
endfunction()


function(minimal_slides file)
    project(${file} NONE)

    pandoc_document(
            TARGET ${file}.pdf
            SOURCES ${file}.md
            PARAMS -t beamer -V lang=en-US -V aspectratio=1610
    )
endfunction()


minimal_script(minimal_script)
minimal_slides(minimal_slides)
