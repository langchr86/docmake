cmake_minimum_required(VERSION 3.10)

include(CMakePackageConfigHelpers)

set(CMAKE_CONFIG_FILE ${CMAKE_CURRENT_BINARY_DIR}/docmake-config.cmake)
set(MODULE_SEARCH_DIR lib/cmake)
set(MODULE_INSTALL_DIR ${MODULE_SEARCH_DIR}/${PROJECT_NAME})

configure_package_config_file(
        docmake-config.cmake.in
        ${CMAKE_CONFIG_FILE}
        INSTALL_DESTINATION ${MODULE_INSTALL_DIR}
        PATH_VARS MODULE_SEARCH_DIR
)

file(GLOB_RECURSE modules "${CMAKE_SOURCE_DIR}/modules/${PROJECT_NAME}/*.cmake")
file(GLOB_RECURSE scripts "${CMAKE_SOURCE_DIR}/modules/${PROJECT_NAME}/*.sh")

install(
        FILES
        ${CMAKE_CONFIG_FILE}
        ${modules}
        DESTINATION ${MODULE_INSTALL_DIR}
)

install(
        PROGRAMS
        ${scripts}
        DESTINATION ${MODULE_INSTALL_DIR}
)
