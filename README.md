# cmake-sandbox

Setup:
```
sudo dnf install -y python-devel
sudo dnf install -y libevent libevent-devel
sudo dnf install -y fmt fmt-devel
sudo dnf install -y boost boost-devel
sudo dnf install -y double-conversion double-conversion-devel
sudo dnf install -y gflags gflags-devel glog glog-devel
sudo dnf install -y folly-devel

mkdir third_party
cd third_party
git clone --depth 1 --branch v3.2.0 https://github.com/jarro2783/cxxopts
git clone --depth 1 --branch 20240116.1 https://github.com/abseil/abseil-cpp.git
```