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

#set(Boost_USE_STATIC_LIBS OFF) 
#set(Boost_USE_STATIC_RUNTIME OFF) 

set(boost_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/boost)
ExternalProject_Add(
    boost
    PREFIX ${boost_PREFIX}
    URL "http://netcologne.dl.sourceforge.net/project/boost/boost/1.69.0/boost_1_69_0.tar.gz"
    URL_MD5 "b50944c0c13f81ce2c006802a1186f5a"
    CONFIGURE_COMMAND ${boost_PREFIX}/src/boost/bootstrap.sh --prefix=${boost_PREFIX}
    BUILD_COMMAND ./bjam link=static cxxflags='-fPIC'
    INSTALL_COMMAND ./bjam link=static install
    BUILD_IN_SOURCE 1
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(Boost_INCLUDE_DIRS ${boost_PREFIX})
set(Boost_LIBRARIES ${boost_PREFIX}/lib/)
message(STATUS "Using Boost from ${Boost_INCLUDE_DIRS}/include")

set(folly_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/external/folly")
ExternalProject_Add(
    folly
    PREFIX ${folly_PREFIX}
    DEPENDS boost
    INSTALL_DIR ${folly_PREFIX}
    GIT_REPOSITORY "https://github.com/facebook/folly.git"
    GIT_TAG "v2024.03.11.00"
    CMAKE_ARGS -DBOOST_DEBUG=ON -DBOOST_INCLUDEDIR=${boost_PREFIX}/include -DBOOST_LIBRARYDIR=${boost_PREFIX}/lib -DBoost_NO_SYSTEM_PATHS=ON -DCMAKE_INSTALL_PREFIX=${folly_PREFIX} -DCMAKE_INCLUDE_PATH=${Boost_INCLUDE_DIRS} -DCMAKE_LIBRARY_PATH=${Boost_LIBRARIES}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND sudo $(MAKE) install
    GIT_PROGRESS TRUE
)
set(folly_INCLUDE_DIRS ${folly_PREFIX})
set(folly_LIBRARIES ${folly_PREFIX}/installed/folly/lib/libfolly.a)
message(STATUS "Using folly from ${folly_INCLUDE_DIRS}/include")

add_executable(hello 
    hello.cc
)