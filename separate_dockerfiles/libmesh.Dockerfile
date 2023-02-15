FROM bridel-slepc:latest

# User clang as default compiler (through the MPIch wrapper)
ENV CC /opt/petsc/bin/mpicc
ENV CXX /opt/petsc/bin/mpic++

# Setup PETSc location
ENV PETSC_DIR /opt/petsc
# ENV PETSC_ARCH docker-opt

# Setup SLEPc location
ENV SLEPC_DIR /opt/slepc
ENV CPPFLAGS -I/opt/slepc/include

# Compile LibMesh with latest clang
RUN apk add --no-cache curl build-base gfortran clang perl cmake git m4 python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools && \
    cd /tmp/ && \
    git clone --branch master --recursive https://github.com/libMesh/libmesh.git && \
    cd `ls | grep libmesh` && \
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
RUN apk del curl build-base gfortran clang perl cmake git m4 python3 && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

# Setup LibMesh location
ENV LIBMESH_DIR /opt/libmesh

LABEL maintainer="thibault[dot]bridelbertomeu[at]gmail[dot]com""
