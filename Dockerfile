# Note, TARGET_ARCH must be defined as a build-time arg, it is deliberately different
# from TARGETARCH which is defined by docker. The reason is because TARGETARCH=amd64
# but we need TARGET_ARCH=x86_64
ARG TARGET_ARCH=x86_64
ARG MANYLINUX_TAG=2025.09.13-2
FROM quay.io/pypa/manylinux_2_28_${TARGET_ARCH}:${MANYLINUX_TAG} AS builder

ARG NINJA_VERSION=1.12.1
# Has to be repeated here so it's imported from the "top level" above the FROM
ARG TARGET_ARCH

WORKDIR /build/

RUN --mount=type=cache,target=/cache \
    if [[ "$TARGET_ARCH" == "aarch64" ]]; then NINJA_ARCH="-aarch64"; else NINJA_ARCH=""; fi \
    && echo "Getting Ninja for '${NINJA_ARCH}'" \
    && curl -fsSL -o /cache/ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux${NINJA_ARCH}.zip \
    && unzip /cache/ninja-linux.zip -d /usr/local/bin \
    && ninja --version \
    && yum install -y openblas-devel
COPY CMakeLists.txt /build/
RUN --mount=type=cache,target=/cache \
    echo true \
    && cmake -G Ninja -S . -B build \
    && pushd build \
    && ninja \
    && popd \
    && rm -rf build
