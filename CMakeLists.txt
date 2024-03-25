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

set(Boost_USE_STATIC_LIBS OFF) 
set(boost_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/boost)
ExternalProject_Add(
    boost
    PREFIX ${boost_PREFIX}
    URL "https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.gz"
    URL_MD5 "ae3f48777db74c0309b49becc2eddada"
    CONFIGURE_COMMAND ${boost_PREFIX}/src/boost/bootstrap.sh --with-libraries=context,filesystem,program_options,regex,system,thread --prefix=${boost_PREFIX}
    BUILD_COMMAND ./b2 cxxflags='-fPIC' --prefix=${boost_PREFIX}
    INSTALL_COMMAND ./b2 install --prefix=${boost_PREFIX}
    BUILD_IN_SOURCE 1
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(Boost_INCLUDE_DIR ${boost_PREFIX}/include)
set(Boost_LIBRARIES ${boost_PREFIX}/lib/)
set(BOOST_ROOT ${boost_PREFIX})
message(STATUS "Using Boost from ${Boost_INCLUDE_DIR}")

set(DoubleConversion_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/double-conversion)
ExternalProject_Add(
    DoubleConversion
    PREFIX ${DoubleConversion_PREFIX}
    INSTALL_DIR ${DoubleConversion_PREFIX}
    GIT_REPOSITORY "https://github.com/google/double-conversion.git"
    GIT_TAG "v3.3.0"
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${DoubleConversion_PREFIX} 
    BUILD_COMMAND $(MAKE)
    BUILD_IN_SOURCE 1
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(DoubleConversion_INCLUDE_DIR ${DoubleConversion_PREFIX}/include)
set(DoubleConversion_LIBRARIES ${DoubleConversion_PREFIX}/lib64/)
message(STATUS "Using DoubleConversion from ${DoubleConversion_INCLUDE_DIR}")

set(Gflags_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/gflags)
ExternalProject_Add(
    Gflags
    PREFIX ${Gflags_PREFIX}
    INSTALL_DIR ${Gflags_PREFIX}
    GIT_REPOSITORY "https://github.com/gflags/gflags.git"
    GIT_TAG "v2.2.0"
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${Gflags_PREFIX} 
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
    BUILD_IN_SOURCE 1
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(Gflags_INCLUDE_DIR ${Gflags_PREFIX}/include)
set(Gflags_LIBRARIES ${Gflags_PREFIX}/lib/)
message(STATUS "Using gflags from ${Gflags_INCLUDE_DIR}")

set(Glog_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/glog)
ExternalProject_Add(
    Glog
    PREFIX ${Glog_PREFIX}
    DEPENDS Gflags
    INSTALL_DIR ${Glog_PREFIX}
    GIT_REPOSITORY "https://github.com/google/glog.git"
    GIT_TAG "v0.6.0"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${Glog_PREFIX}
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(Glog_INCLUDE_DIR ${Glog_PREFIX}/include)
set(Glog_LIBRARIES ${Glog_PREFIX}/lib64/)
message(STATUS "Using glog from ${Glog_INCLUDE_DIR}")

set(fmt_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/fmt)
ExternalProject_Add(
    fmt
    PREFIX ${fmt_PREFIX}
    INSTALL_DIR ${fmt_PREFIX}
    GIT_REPOSITORY "https://github.com/fmtlib/fmt.git"
    GIT_TAG "10.2.1"
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${fmt_PREFIX} -DBUILD_SHARED_LIBS=TRUE
    LOG_UPDATE ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON
)
set(fmt_INCLUDE_DIR ${fmt_PREFIX}/include)
set(fmt_LIBRARIES ${fmt_PREFIX}/lib64/)
message(STATUS "Using fmt from ${fmt_INCLUDE_DIR}")



set(folly_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/external/folly")
ExternalProject_Add(
    folly
    PREFIX ${folly_PREFIX}
    DEPENDS boost
    DEPENDS DoubleConversion
    DEPENDS Gflags
    DEPENDS Glog
    DEPENDS fmt
    INSTALL_DIR ${folly_PREFIX}
    GIT_REPOSITORY "https://github.com/facebook/folly.git"
    GIT_TAG "v2024.03.11.00"
    CMAKE_ARGS -DLIBFMT_LIBRARY=${fmt_LIBRARIES}/libfmt.so -DLIBFMT_INCLUDE_DIR=${fmt_INCLUDE_DIR} -DGLOG_LIBRARY=${Glog_LIBRARIES} -DGLOG_INCLUDE_DIR=${Glog_INCLUDE_DIR} -DLIBGFLAGS_LIBRARY=${Gflags_LIBRARIES} -DLIBGFLAGS_INCLUDE_DIR=${Gflags_INCLUDE_DIR} -DDOUBLE_CONVERSION_LIBRARY=${DoubleConversion_LIBRARIES} -DDOUBLE_CONVERSION_INCLUDE_DIR=${DoubleConversion_INCLUDE_DIR} -DBOOST_DEBUG=ON -DBOOST_ROOT=${boost_PREFIX} -DBOOST_INCLUDEDIR=${Boost_INCLUDE_DIR} -DBOOST_LIBRARYDIR=${boost_LIBRARIES} -DBoost_NO_SYSTEM_PATHS=ON -DCMAKE_INSTALL_PREFIX=${folly_PREFIX} -DCMAKE_INCLUDE_PATH=${Boost_INCLUDE_DIR},${DoubleConversion_INCLUDE_DIR},${Gflags_INCLUDE_DIR},${Glog_INCLUDE_DIR},${fmt_LIBRARIES} -DCMAKE_LIBRARY_PATH=${Boost_LIBRARIES},${DoubleConversion_LIBRARIES},${Gflags_LIBRARIES},${Glog_LIBRARIES},${fmt_LIBRARIES}
    BUILD_COMMAND $(MAKE)
    INSTALL_COMMAND $(MAKE) install
    GIT_PROGRESS TRUE
)
set(folly_INCLUDE_DIRS ${folly_PREFIX})
set(folly_LIBRARIES ${folly_PREFIX}/installed/folly/lib/libfolly.a)
message(STATUS "Using folly from ${folly_INCLUDE_DIRS}/include")

add_executable(hello 
    hello.cc
)