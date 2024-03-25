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

find_package(gflags REQUIRED)
find_package(folly REQUIRED)

add_executable(hello 
    hello.cc
)
target_link_libraries(hello
    ${FOLLY_LIBRARIES}
)