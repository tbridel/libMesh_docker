FROM alpine@sha256:a3f76a0741171f1cdd97371fa0d239bb46aa1c8985e8487380a2282311deb3c9

# User clang as default compiler
ENV CC clang
ENV CXX clang++

# Compile openblas with latest clang
RUN apk add --no-cache curl build-base gfortran clang perl linux-headers && \
    mkdir -p /etc/ld.so.conf.d/ && \
    echo "/opt/OpenBLAS/lib" > /etc/ld.so.conf.d/openblas.conf && \
    cd /tmp/ && \
    curl -L https://github.com/xianyi/OpenBLAS/archive/develop.tar.gz | tar xz && \
    cd `ls | grep OpenBLAS` && \
    make TARGET=ARMV8 NO_AFFINITY=1 NUM_THREADS=1 && \
    make install && \
    apk del curl build-base gfortran clang perl linux-headers && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

LABEL maintainer="thibault[dot]bridelbertomeu[at]re[dash]cae[dot]com"
