include(docmake/pandoc)

function(minimal_script file)
    project(${file} NONE)

    pandoc_document(
            TARGET ${file}.pdf
            SOURCES ${file}.md
            PARAMS -V lang=de-CH
    )
endfunction()


function(minimal_slides file)
    project(${file} NONE)

    pandoc_document(
            TARGET ${file}.pdf
            SOURCES ${file}.md
            PARAMS -t beamer -V lang=de-CH -V aspectratio=1610
    )
endfunction()


minimal_script(script)
minimal_slides(slides)
