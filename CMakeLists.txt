cmake_minimum_required(VERSION 3.15)

project(Hello VERSION 0.1
	DESCRIPTION "Test cmake build structure for RHEL"
	LANGUAGES CXX)

# Setting the C++ version to 17 for folly compatibility
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "-Wall -O3")
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(gflags REQUIRED)
find_package(folly REQUIRED)

add_subdirectory(third_party/cxxopts)
# add_subdirectory(third_party/abseil-cpp)

include(FetchContent)
set(ABSL_ENABLE_INSTALL ON) # bug fix: https://stackoverflow.com/questions/76697852/using-fetchcontent-to-retrieve-protobuf-and-grpc-to-compile-during-build-hermet
FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc
  GIT_TAG        v1.55.1
)
set(FETCHCONTENT_QUIET OFF)
FetchContent_MakeAvailable(gRPC)

add_library(helloproto OBJECT "${CMAKE_CURRENT_LIST_DIR}/helloworld.proto")
target_link_libraries(helloproto PUBLIC protobuf::libprotobuf)
set(PROTO_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
target_include_directories(helloproto PUBLIC "$<BUILD_INTERFACE:${PROTO_BINARY_DIR}>")

protobuf_generate(
    TARGET helloproto
    LANGUAGE grpc
    GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc
    PLUGIN "protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>"
    IMPORT_DIRS ${PROTO_IMPORT_DIRS}
    PROTOC_OUT_DIR "${PROTO_BINARY_DIR}")

add_executable(hello 
    hello.cc
)
target_link_libraries(hello
    ${FOLLY_LIBRARIES}
    cxxopts::cxxopts
    absl::flat_hash_map
    grpc++
    helloproto
)