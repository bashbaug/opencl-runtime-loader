# Copyright (c) 2020 Ben Ashbaugh
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_CXX_STANDARD 11)

project(OpenCLRuntimeLoader LANGUAGES CXX)

if(NOT ${OpenCL_INCLUDE_DIRS})
    find_package(OpenCL)
endif()
include_directories(
    ${OpenCL_INCLUDE_DIRS}
)

set( OpenCLRuntimeLoader_SOURCE_FILES
    src/loader.cpp
)

source_group(Source FILES ${OpenCLRuntimeLoader_SOURCE_FILES})

add_library(OpenCLRuntimeLoader STATIC ${OpenCLRuntimeLoader_SOURCE_FILES})
set_target_properties(OpenCLRuntimeLoader PROPERTIES FOLDER "OpenCLRuntimeLoader")
target_link_libraries(OpenCLRuntimeLoader ${CMAKE_DL_LIBS})
target_compile_definitions(OpenCLRuntimeLoader PRIVATE CL_TARGET_OPENCL_VERSION=220)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    target_compile_options(OpenCLRuntimeLoader PRIVATE /EHsc)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    target_compile_options(OpenCLRuntimeLoader PRIVATE -Wall)
    set_target_properties(OpenCLRuntimeLoader PROPERTIES LINK_FLAGS "-Wl,--version-script")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    # TODO
endif()

install (TARGETS OpenCLRuntimeLoader
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib)
