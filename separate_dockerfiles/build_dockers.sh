#! /bin/zsh

docker build \
    --pull \
    --rm \
    --cache-from bridel-openblas:latest \
    -f openblas.Dockerfile \
    -t bridel-openblas:latest \
    .

docker build \
    --rm \
    --cache-from bridel-petsc:latest \
    -f petsc.Dockerfile \
    -t bridel-petsc:latest \
    .

docker build \
    --rm \
    --cache-from bridel-slepc:latest \
    -f slepc.Dockerfile \
    -t bridel-slepc:latest \
    .

docker build \
    --rm \
    --cache-from bridel-libmesh:latest \
    -f libmesh.Dockerfile \
    -t bridel-libmesh:latest \
    .