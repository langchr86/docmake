cmake_minimum_required(VERSION 3.10)

project(docmake)

option(DOCMAKE_ENABLE_MINIMAL_EXAMPLE OFF)
option(DOCMAKE_ENABLE_MAXIMAL_EXAMPLE OFF)
option(DOCMAKE_SELF_CONTAINED_EXAMPLES ON)

add_subdirectory(installation)
add_subdirectory(samples)
