# ******************************************************************************
# Copyright 2026 IBM Corporation and affiliates.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ******************************************************************************

if(zdnn_cmake_included)
    return()
endif()
set(zdnn_cmake_included true)
include("cmake/options.cmake")

if(NOT DNNL_TARGET_ARCH STREQUAL "S390X")
    return()
endif()

if(NOT DNNL_S390X_USE_ZDNN)
    return()
endif()

find_package(ZDNN REQUIRED)

# Required minimum zDNN version for NNPA support.
set(ZDNN_MIN_MAJOR_VERSION "1")
set(ZDNN_MIN_MINOR_VERSION "2")
set(ZDNN_MIN_VERSION "${ZDNN_MIN_MAJOR_VERSION}.${ZDNN_MIN_MINOR_VERSION}")

if(ZDNN_FOUND)
    # Version check via zdnn.h ZDNN_VERSION macro
    if(EXISTS "${ZDNN_INCLUDE_DIR}/zdnn.h")
        file(READ "${ZDNN_INCLUDE_DIR}/zdnn.h" ZDNN_HEADER_CONTENTS)

	if("${ZDNN_HEADER_CONTENTS}" MATCHES "#define ZDNN_VERSION \"([0-9]+)\\.([0-9]+)")
            set(ZDNN_FOUND_MAJOR_VERSION "${CMAKE_MATCH_1}")
            set(ZDNN_FOUND_MINOR_VERSION "${CMAKE_MATCH_2}")
            set(ZDNN_FOUND_VERSION "${ZDNN_FOUND_MAJOR_VERSION}.${ZDNN_FOUND_MINOR_VERSION}")

            if("${ZDNN_FOUND_VERSION}" VERSION_LESS "${ZDNN_MIN_VERSION}")
                message(FATAL_ERROR
                    "Detected zDNN version ${ZDNN_FOUND_VERSION}, but minimum "
                    "compatible version is ${ZDNN_MIN_VERSION}\n"
                )
            endif()

            message(STATUS "zDNN version: ${ZDNN_FOUND_VERSION}")
        else()
            message(WARNING
                "Build may fail. Could not determine zDNN version.\n"
                "Minimum compatible zDNN version is ${ZDNN_MIN_VERSION}\n"
            )
        endif()
    else()
        message(WARNING
            "Build may fail. Could not find zdnn.h in ${ZDNN_INCLUDE_DIR}\n"
        )
    endif()

    list(APPEND EXTRA_SHARED_LIBS ${ZDNN_LIBRARIES})

    include_directories(${ZDNN_INCLUDE_DIRS})

    message(STATUS "zDNN library: ${ZDNN_LIBRARIES}")
    message(STATUS "zDNN headers: ${ZDNN_INCLUDE_DIRS}")

    add_definitions(-DDNNL_S390X_USE_ZDNN)
endif()
