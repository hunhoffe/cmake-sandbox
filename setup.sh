#!/bin/bash

set -x

DO_CLEAN=false

function Clean_Previous_Artifacts()
{
	rm -rf build
	rm -rf third_party
}

# Install System dependencies
function Install_Ubuntu_Dependencies()
{
	echo "Installing Ubuntu Dependencies"
	sudo apt update
	sudo apt install -y numactl cmake
	sudo apt install -y python3-dev
	sudo apt install -y libevent-dev
	sudo apt install -y libfmt-dev
	sudo apt install -y libboost-dev
	sudo apt install -y libdouble-conversion-dev
	sudo apt install -y libgflags-dev libgoogle-glog-dev
	sudo apt install -y folly-dev

	# for grpc
	sudo apt install -y libsystemd-dev
	sudo apt install -y protobuf-compiler
}

function Install_RHEL_Dependencies()
{
	echo "Installing RHEL Dependencies"
	sudo dnf update
	sudo dnf install -y numactl cmake
	sudo dnf install -y python-devel
	sudo dnf install -y libevent libevent-devel
	sudo dnf install -y fmt fmt-devel
	sudo dnf install -y boost boost-devel
	sudo dnf install -y double-conversion double-conversion-devel
	sudo dnf install -y gflags gflags-devel glog glog-devel
	sudo dnf install -y folly-devel

	# for grpc
	sudo dnf install -y systemd-devel
	sudo dnf install -y protobuf-devel protobuf-lite-devel
}

function Download_Dependency_Source_Code()
{
	mkdir third_party
	cd third_party
	git clone --depth 1 --branch v3.2.0 https://github.com/jarro2783/cxxopts
	git clone --depth 1 --branch 20240116.1 https://github.com/abseil/abseil-cpp.git
	cd ..
}

function Build_Project()
{
	mkdir build
	cd build
	cmake ..
	cmake --build .
}

if $DO_CLEAN; then
	echo "Cleaning up artifacts from previous setup/build..."
	Clean_Previous_Artifacts
else
	echo "Not cleaning artifacts from prevous setup/build"
fi

MY_DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
echo "Distro: $MY_DISTRO"

if [ "$MY_DISTRO" = "\"Ubuntu\"" ]; then
	echo "Ubuntu distribution, using apt"
	Install_Ubuntu_Dependencies
else
	echo "Not Ubuntu, assuming RHEL..."
	Install_RHEL_Dependencies
fi

Download_Dependency_Source_Code
Build_Project
