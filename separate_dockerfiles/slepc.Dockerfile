FROM bridel-petsc:latest

# User clang as default compiler
ENV CC clang
ENV CXX clang++

# Setup PETSc location
ENV PETSC_DIR /opt/petsc
# ENV PETSC_ARCH docker-opt

# Compile SLEPc with latest clang
RUN apk add --no-cache curl build-base gfortran clang perl cmake python3 linux-headers && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools && \
    cd /tmp/ && \
    curl -L https://slepc.upv.es/download/distrib/slepc-3.18.2.tar.gz | tar xz && \
    cd `ls | grep slepc` && \
    ./configure --prefix=/opt/slepc && \
    make SLEPC_DIR=/tmp/slepc-3.18.2 PETSC_DIR=/opt/petsc && \
    make SLEPC_DIR=/tmp/slepc-3.18.2 PETSC_DIR=/opt/petsc install && \
    apk del curl build-base gfortran clang perl cmake python3 linux-headers && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

# Setup SLEPc location
ENV SLEPC_DIR /opt/slepc

LABEL maintainer="thibault[dot]bridelbertomeu[at]gmail[dot]com"
