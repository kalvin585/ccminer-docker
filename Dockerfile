#
# Dockerfile for KlausT/ccminer
# usage: nvidia-docker run kalvin585/ccminer --url xxxx --user xxxx --pass xxxx
# ex: nvidia-docker run kalvin585/ccminer -a neoscrypt -o stratum+tcp://neoscrypt.mine.zpool.ca:4233 -u 1P9uwDkvPhzp6rheW8Tzmd4GaYvSxcSSFE -p c=BTC,stats,d=32,id=`hostname -s`
#

FROM nvidia/cuda:9.0-devel
MAINTAINER Kalvin Harris <harriskalvin585@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/zzz-no-recommends \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv E5267A6C \
 && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list.d/libssl1.1.list \
 && apt-get update && apt-get install -y \
    git ca-certificates build-essential automake autotools-dev \
    libssl-dev libcurl4-openssl-dev libjansson-dev \
    libcurl3 libjansson4 libssl1.1 \
 && git clone https://github.com/KlausT/ccminer \
 && cd ccminer && sed -i 's|-march=native|-march=native -std=gnu++11|' configure.sh \
 && ./build.sh && strip ./ccminer && chmod +x ./ccminer && mv ./ccminer /usr/local/bin/ccminer \
 && apt-get remove --purge --auto-remove -y \
    git ca-certificates build-essential automake autotools-dev \
    libssl-dev libcurl4-openssl-dev libjansson-dev \
 && rm -rf /tmp/* /var/lib/apt/lists/* /etc/apt/apt.conf.d/zzz-no-recommends /etc/apt/sources.list.d/libssl1.1.list \
 && apt-get clean -y

ENTRYPOINT ["/usr/local/bin/ccminer"]
