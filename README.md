# ccminer-docker
The repository contains Dockerfile for tpruvot/ccminer build

Usage: nvidia-docker run kalvin585/ccminer --url xxxx --user xxxx --pass xxxx

Example:
nvidia-docker run kalvin585/ccminer -a neoscrypt -o stratum+tcp://neoscrypt.mine.zpool.ca:4233 -u 1P9uwDkvPhzp6rheW8Tzmd4GaYvSxcSSFE -p c=BTC,stats,d=32,id=$(hostname -s)
