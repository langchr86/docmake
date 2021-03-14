list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules")

if (DOCMAKE_ENABLE_MINIMAL_EXAMPLE)
    add_subdirectory(minimal)
endif ()

if (DOCMAKE_ENABLE_MAXIMAL_EXAMPLE)
    add_subdirectory(maximal)
endif ()
