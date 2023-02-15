# libMesh in a whale :whale:

This tiny repo contains:
- a "solid state", _a.k.a._ "all-in-one" Dockerfile that provides a stable working environment for `libMesh` on a Debian kernel,
- a series of Dockerfiles that, put together, can lead to a successfull install of `libMesh` on a containerized Debian kernel.

This work is inspired by the work done by [@canesin](https://github.com/canesin/libmesh-git-docker) some years ago.

The Dockerfiles can be used as-is to run a `libMesh` friendly environment using _e.g._ the following command:

```bash
docker run --rm -it  bridel/libmesh_debian:latest
```

after which, for example, a Visual Studio Code instance can be attached to the container to develop `libMesh`-based code (see [here](https://code.visualstudio.com/docs/devcontainers/containers)).
In the same spirit, a Visual Studio Code basic `devcontainer.json` is also provided so that it is possible to spin up the solid state Dockerfile and develop code from this repo directly in the Debian container.