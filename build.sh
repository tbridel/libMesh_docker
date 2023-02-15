#! /bin/bash

# The SHA passed here matches libmesh master HEAD on Feb 15th, 2023
docker build \
    --rm \
    --cache-from bridel/libmesh_debian:latest \
    -f libmesh_debian.Dockerfile \
    --build-arg BASE_IMAGE=alpine:edge \
    --build-arg PETSC_VERSION=3.18 \
    --build-arg SLEPC_VERSION=3.18.2 \
    --build-arg LIBMESH_SHA=18406c84932d5f9e325d83a8b84b779a249c7bfd \
    -t bridel/libmesh_debian:latest \
    .