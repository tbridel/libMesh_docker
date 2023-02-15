FROM bridel-openblas:latest

# User clang as default compiler
ENV CC clang
ENV CXX clang++

# Compile PETSc with latest clang
RUN apk add --no-cache curl build-base gfortran clang perl cmake python3 linux-headers && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools && \
    cd /tmp/ && \
    curl -L http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.tar.gz | tar xz && \
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
    make install && \
    apk del curl build-base gfortran clang perl cmake python3 linux-headers && \
    rm -rf /usr/share/man/* /tmp/* /var/cache/apk/*

# Setup PETSc location
ENV PETSC_DIR /opt/petsc
# ENV PETSC_ARCH docker-opt

LABEL maintainer="thibault[dot]bridelbertomeu[at]re[dash]cae[dot]com"
