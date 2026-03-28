# FindZDNN.cmake
# Finds the zDNN library for IBM Z NNPA acceleration.
#
# This module defines:
#   ZDNN_FOUND            - True if zDNN was found
#   ZDNN_INCLUDE_DIRS     - Include directories for zdnn.h
#   ZDNN_LIBRARIES        - zDNN library to link against
#   ZDNN::ZDNN            - Imported target
#
# Users can also hint the location via:
#   -DZDNN_ROOT_DIR=<path>   (CMake variable)
#   ZDNN_ROOT env variable   (environment variable)

find_path(ZDNN_INCLUDE_DIR
    NAMES zdnn.h
    HINTS
        ${ZDNN_ROOT_DIR}/include
        $ENV{ZDNN_ROOT}/include
    PATHS
        /usr/include
        /usr/local/include)

find_library(ZDNN_LIBRARY
    NAMES zdnn
    HINTS
        ${ZDNN_ROOT_DIR}/lib
        ${ZDNN_ROOT_DIR}/lib64
        $ENV{ZDNN_ROOT}/lib
        $ENV{ZDNN_ROOT}/lib64
    PATHS
        /usr/lib
        /usr/lib64
        /usr/local/lib
        /usr/local/lib64)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZDNN
    REQUIRED_VARS ZDNN_LIBRARY ZDNN_INCLUDE_DIR
    FAIL_MESSAGE "zDNN not found. Set ZDNN_ROOT_DIR to your zDNN install prefix.")

if(ZDNN_FOUND)
    set(ZDNN_LIBRARIES ${ZDNN_LIBRARY})
    set(ZDNN_INCLUDE_DIRS ${ZDNN_INCLUDE_DIR})

    if(NOT TARGET ZDNN::ZDNN)
        add_library(ZDNN::ZDNN UNKNOWN IMPORTED)
        set_target_properties(ZDNN::ZDNN PROPERTIES
            IMPORTED_LOCATION             "${ZDNN_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${ZDNN_INCLUDE_DIR}")
    endif()
endif()

mark_as_advanced(ZDNN_INCLUDE_DIR ZDNN_LIBRARY)
