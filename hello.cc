#include <iostream>
#include "folly/MPMCQueue.h"
#include <cxxopts.hpp>

int main(int argc, char* argv[]) {
    folly::MPMCQueue<uint> *q = new folly::MPMCQueue<uint>(10);
    cxxopts::Options options("embarcadero", "a totally ordered pub/sub system with CXL");
    std::cout << "Hello!" << std::endl;
}