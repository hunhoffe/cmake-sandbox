#include <iostream>
#include "folly/MPMCQueue.h"

int main(int argc, char* argv[]) {
    folly::MPMCQueue<uint> *q = new folly::MPMCQueue<uint>(10);
    std::cout << "Hello!" << std::endl;
}