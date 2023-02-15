# Solid state, "all-in-one", Dockerfile to have a Debian-based libmesh install.

ARG BASE_IMAGE=alpine:edge
FROM ${BASE_IMAGE}

# Dependencies
RUN apk add --no-cache curl build-base gfortran clang perl cmake python3 linux-headers git m4 bash
RUN ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools

# OpenBLAS
ENV CC clang
ENV CXX clang++
RUN mkdir -p /etc/ld.so.conf.d/ && \
    echo "/opt/OpenBLAS/lib" > /etc/ld.so.conf.d/openblas.conf && \
    cd /tmp/ && \
    curl -L https://github.com/xianyi/OpenBLAS/archive/develop.tar.gz | tar xz && \
    cd `ls | grep OpenBLAS` && \
    make NO_AFFINITY=1 NUM_THREADS=1 && \
    make install

# PETSc
ARG PETSC_VERSION=3.18
RUN cd /tmp/ && \
    curl -L http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz | tar xz && \
    cd `ls | grep petsc` && \
    ./configure PETSC_ARCH=docker-opt \
        CC=$CC \
        CXX=$CXX \
        --prefix=/opt/petsc \
        --known-64-bit-blas-indices=false \
        --with-blas-lapack-lib=/opt/OpenBLAS/lib/libopenblas.a \
        --download-mpich \
        --download-scalapack \
        --download-mumps \
        --download-superlu_dist \
        --download-metis \
        --download-parmetis \
        --download-hypre \
        --with-debugging=0 \
        COPTFLAGS='-O2' \
        CXXOPTFLAGS='-O2' \
        FOPTFLAGS='-O2' && \
    make && \
    make install
ENV PETSC_DIR /opt/petsc

# SLEPc
ARG SLEPC_VERSION=3.18.2
RUN cd /tmp/ && \
    curl -L https://slepc.upv.es/download/distrib/slepc-${SLEPC_VERSION}.tar.gz | tar xz && \
    cd `ls | grep slepc` && \
    ./configure --prefix=/opt/slepc && \
    make SLEPC_DIR=/tmp/slepc-3.18.2 PETSC_DIR=/opt/petsc && \
    make SLEPC_DIR=/tmp/slepc-3.18.2 PETSC_DIR=/opt/petsc install
ENV SLEPC_DIR /opt/slepc

# LibMesh
ARG LIBMESH_SHA=master
ENV CC /opt/petsc/bin/mpicc
ENV CXX /opt/petsc/bin/mpic++
ENV CPPFLAGS -I/opt/slepc/include
RUN cd /tmp/ && \
    git clone --recursive https://github.com/libMesh/libmesh.git && \
    cd `ls | grep libmesh` && \
    git checkout ${LIBMESH_SHA} && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/libmesh \
        --with-methods="opt dbg" \
        --with-metis=PETSc \
        --enable-ifem \
        --enable-perflog \
        --enable-silent-rules \
        --enable-unique-id \
        --disable-fortran \
        --disable-pthreads && \
    make && \
    make install
ENV LIBMESH_DIR /opt/libmesh
ENV LIBMESH_INCLUDE /opt/libmesh/include
ENV LIBMESH_LIB /opt/libmesh/lib

# User-friendliness
ENV SHELL=/bin/bash
RUN addgroup -g 1000 libmesh_container
RUN adduser -u 2000 -G libmesh_container -s /bin/bash -D libmesh_user
ENV PATH=/home/libmesh_user/.local/bin:$PATH
RUN cp -r /opt/libmesh/examples /home/libmesh_user/.
WORKDIR /home/libmesh_user
