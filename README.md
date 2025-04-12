'manylinux' Docker images are used to build Python extension modules compatible with many popular Linux distributions. This repository builds several dependencies on top of the [standard manylinux images](https://quay.io/organization/pypa), for use in building Cantera.

Images are published on the GitHub container registry:

- [cantera-base-manylinux_2_28-x86_64](https://github.com/orgs/Cantera/packages/container/package/cantera-base-manylinux_2_28-x86_64)
- [cantera-base-manylinux_2_28-aarch64](https://github.com/orgs/Cantera/packages/container/package/cantera-base-manylinux_2_28-aarch64)

To build an image locally for testing you need to specify two build arguments for Docker:

- `TARGET_ARCH`: One of the supported architectures for manylinux images
  - `x86_64`
  - `aarch64`
  - `s390x`
  - `ppc64le`
- `MANYLINUX_TAG`: A tag in the Quay repository: https://quay.io/organization/pypa

The images are currently based on `manylinux_2_28`, which includes version 2.28 of glibc per [PEP 600](https://peps.python.org/pep-0600/). This means that wheels built with `manylinux_2_28` will work on any Linux distribution that ships glibc 2.28 _or newer_. The upstream `manylinux` project README has a good summary of [compatibility with different Linux distros](https://github.com/pypa/manylinux?tab=readme-ov-file#manylinux_2_28-almalinux-8-based).

> Note: The manylinux project is working on releasing `manylinux_2_34` and has images available. However, there is a problem with how the compilers are configured that will break our wheels because we install openblas with `dnf`. See issue [pypa/manylinux#1725](https://github.com/pypa/manylinux/issues/1725).
