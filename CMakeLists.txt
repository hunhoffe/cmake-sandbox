# Setting the cmake version to 3.5 for abseil compatibility
cmake_minimum_required(VERSION 3.5)

project(Embarcadero VERSION 0.1
	DESCRIPTION "Pubsub with disaggregated memory"
	LANGUAGES CXX)

include(ExternalProject)

# Setting the C++ version to 17 for folly compatibility
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "-Wall -O3")
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_VERBOSE_MAKEFILE ON)

set(folly_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/external/folly")
ExternalProject_Add(
    folly
    PREFIX ${folly_PREFIX}
    INSTALL_DIR ${folly_PREFIX}
    GIT_REPOSITORY "https://github.com/facebook/folly.git"
    GIT_TAG "v2024.03.11.00"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${folly_PREFIX}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
    GIT_PROGRESS TRUE
)
set(folly_INCLUDE_DIRS ${folly_PREFIX})
set(folly_LIBRARY_DIR ${folly_PREFIX}/installed/folly/lib/libfolly.a)
message(STATUS "Using folly from ${folly_INCLUDE_DIRS}/include")

add_executable(hello 
    hello.cc
)