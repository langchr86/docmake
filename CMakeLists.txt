cmake_minimum_required(VERSION 3.10)

project(docmake)

option(DOCMAKE_ENABLE_MINIMAL_EXAMPLE "Enable the minimal example project" OFF)
option(DOCMAKE_ENABLE_MAXIMAL_EXAMPLE "Enable the maximal example project" OFF)
option(DOCMAKE_SELF_CONTAINED_EXAMPLES "Use the cmake modules directly without the need to install them" ON)

add_subdirectory(installation)
add_subdirectory(samples)
