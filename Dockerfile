# Note, TARGET_ARCH must be defined as a build-time arg, it is deliberately different
# from TARGETARCH which is defined by docker. The reason is because TARGETARCH=amd64
# but we need TARGET_ARCH=x86_64
ARG TARGET_ARCH
FROM quay.io/pypa/manylinux_2_28_${TARGET_ARCH}:2024-10-05-46a4cc2 AS builder

ARG NINJA_VERSION=1.12.1
# Has to be repeated here so it's imported from the "top level" above the FROM
ARG TARGET_ARCH


RUN --mount=type=cache,target=/cache \
    if [[ "$TARGET_ARCH" == "aarch64" ]]; then NINJA_ARCH="-aarch64"; else NINJA_ARCH=""; fi \
    && echo "Getting Ninja for '${NINJA_ARCH}'" \
    && curl -fsSL -o /cache/ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux${NINJA_ARCH}.zip \
    && unzip /cache/ninja-linux.zip -d /usr/local/bin \
    && ninja --version \
    && yum install -y openblas-devel \
    && true
COPY CMakeLists.txt libaec_cmakelists.patch /tmp/
RUN --mount=type=cache,target=/cache \
    true \
    && mkdir build \
    && pushd build \
    && cmake -G Ninja -DLIBAEC_PATCHFILE=/tmp/libaec_cmakelists.patch ../tmp \
    && ninja \
    && popd \
    && rm -rf build

FROM builder AS tester

RUN yum install -y python3.12-pip \
    && python3.12 -m pip install --root-user-action=ignore build auditwheel

COPY cantera-3.1.0a4.tar.gz /project/

RUN --mount=type=cache,target=/root/.cache \
    pushd project \
    && tar --strip-components=1 -zxf cantera-*.tar.gz \
    && rm -f cantera-*.tar.gz \
    && python3.12 -m build --wheel . \
    && pushd dist \
    && auditwheel repair -w . cantera*.whl
