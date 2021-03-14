if (DOCMAKE_SELF_CONTAINED_EXAMPLES)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules")
else ()
    find_package(docmake)
endif ()

if (DOCMAKE_ENABLE_MINIMAL_EXAMPLE)
    add_subdirectory(minimal)
endif ()

if (DOCMAKE_ENABLE_MAXIMAL_EXAMPLE)
    add_subdirectory(maximal)
endif ()
