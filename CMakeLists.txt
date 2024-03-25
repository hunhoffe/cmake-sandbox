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

set(_PROTOBUF_LIBPROTOBUF libprotobuf)
set(_REFLECTION grpc++_reflection)
set(_ORCA_SERVICE grpcpp_orca_service)
if(CMAKE_CROSSCOMPILING)
  find_program(_PROTOBUF_PROTOC protoc)
else()
  set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)
endif()
set(_GRPC_GRPCPP grpc++)
if(CMAKE_CROSSCOMPILING)
  find_program(_GRPC_CPP_PLUGIN_EXECUTABLE grpc_cpp_plugin)
else()
  set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc_cpp_plugin>)
endif()
find_package(Protobuf REQUIRED)

# Proto file
get_filename_component(hello_proto "hello.proto" ABSOLUTE)
get_filename_component(hello_proto_path "${hello_proto}" PATH)

# Generated sources
set(hello_proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/hello.pb.cc")
set(hello_proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/hello.pb.h")
set(hello_grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/hello.grpc.pb.cc")
set(hello_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/hello.grpc.pb.h")
add_custom_command(
      OUTPUT "${hello_proto_srcs}" "${hello_proto_hdrs}" "${hello_grpc_srcs}" "${hello_grpc_hdrs}"
      COMMAND ${_PROTOBUF_PROTOC}
      ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${hello_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${hello_proto}"
      DEPENDS "${hello_proto}")

# Include generated *.pb.h files
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

add_library(hello_grpc_proto
  ${hello_grpc_srcs}
  ${hello_grpc_hdrs}
  ${hello_proto_srcs}
  ${hello_proto_hdrs})
target_link_libraries(hello_grpc_proto
  ${_REFLECTION}
  ${_GRPC_GRPCPP}
  ${_PROTOBUF_LIBPROTOBUF})

add_executable(hello 
    hello.cc
)
target_link_libraries(hello
    ${FOLLY_LIBRARIES}
    cxxopts::cxxopts
    absl::flat_hash_map
    grpc++
    hello_grpc_proto
)