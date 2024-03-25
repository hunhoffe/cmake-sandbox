#include <iostream>
#include "folly/MPMCQueue.h"
#include <cxxopts.hpp>
#include <absl/container/flat_hash_map.h>

int main(int argc, char* argv[]) {
    folly::MPMCQueue<uint> *q = new folly::MPMCQueue<uint>(10);
    cxxopts::Options options("embarcadero", "a totally ordered pub/sub system with CXL");
    absl::flat_hash_map<std::string, std::string> peer_brokers_;
    
    std::cout << "Hello!" << std::endl;
}