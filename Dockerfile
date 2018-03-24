#
# Dockerfile for tpruvot/ccminer
# usage: nvidia-docker run kalvin585/ccminer --url xxxx --user xxxx --pass xxxx
# ex: nvidia-docker run kalvin585/ccminer -a neoscrypt -o stratum+tcp://neoscrypt.mine.zpool.ca:4233 -u 1P9uwDkvPhzp6rheW8Tzmd4GaYvSxcSSFE -p c=BTC,stats,d=32,id=`hostname -s`
#

FROM nvidia/cuda:9.1-runtime-ubuntu17.04
MAINTAINER Kalvin Harris <harriskalvin585@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs:${LIBRARY_PATH}

WORKDIR /tmp

COPY *.deb /tmp/

RUN dpkg -i /tmp/*.deb \
 && echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/zzz-no-recommends \
 && sed -i 's|//.\+\.ubuntu\.com/|//old-releases.ubuntu.com/|' /etc/apt/sources.list \
 && apt-get update && apt-get install -y \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    ca-certificates build-essential automake autotools-dev \
    libssl-dev libcurl4-openssl-dev libjansson-dev \
    libcurl3 libjansson4 libgomp1 wget unzip \
 && wget https://github.com/tpruvot/ccminer/archive/linux.zip && unzip -a linux.zip \
 && cd ccminer-linux && sed -i 's|-march=native ||' configure.sh && sed -i 's|CXXFLAGS="-O3 |CXXFLAGS="-Ofast |' configure.sh \
 && ./build.sh && strip -s ./ccminer && chmod +x ./ccminer && mv ./ccminer /usr/local/bin/ccminer \
 && apt-get remove --purge --auto-remove -y \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    ca-certificates build-essential automake autotools-dev \
    libssl-dev libcurl4-openssl-dev libjansson-dev wget unzip \
 && rm -rf /tmp/* /var/lib/apt/lists/* /etc/apt/apt.conf.d/zzz-no-recommends \
 && apt-get clean -y

ENTRYPOINT ["/usr/local/bin/ccminer"]
