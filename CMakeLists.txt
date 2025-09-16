cmake_minimum_required(VERSION 3.24.0)

project(cantera-dependency-superbuild)

include(ExternalProject)

set(DOWNLOAD_DIR "/cache")

set(BOOST_VERSION 1.88.0)
ExternalProject_Add(
    boost
    URL https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz
    URL_HASH SHA256=f48b48390380cfb94a629872346e3a81370dc498896f16019ade727ab72eb1ec
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DBOOST_INCLUDE_LIBRARIES:STRING=algorithm;dll;stacktrace;core;math;numeric/ublas;serialization;multi_array
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(LIBHDF5_VERSION 1.14.6)
set(ZLIB_VERSION 1.3.1)
set(LIBAEC_VERSION 1.1.4)
ExternalProject_Add(
    libhdf5
    URL https://github.com/HDFGroup/hdf5/releases/download/hdf5_${LIBHDF5_VERSION}/hdf5-${LIBHDF5_VERSION}.tar.gz
    URL_HASH SHA256=e4defbac30f50d64e1556374aa49e574417c9e72c6b1de7a4ff88c4b1bea6e9b
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_PREFIX:STRING=/usr/local
        -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON
        -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
        -DHDF5_BUILD_EXAMPLES:BOOL=OFF
        -DHDF5_BUILD_TOOLS:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DHDF5_ALLOW_EXTERNAL_SUPPORT:STRING=TGZ
        -DZLIB_PACKAGE_NAME:STRING=zlib
        -DZLIB_TGZ_NAME:STRING=zlib-${ZLIB_VERSION}.tar.gz
        -DZLIB_TGZ_ORIGPATH:STRING=https://github.com/madler/zlib/releases/download/v${ZLIB_VERSION}
        -DZLIB_USE_LOCALCONTENT:BOOL=OFF
        -DLIBAEC_PACKAGE_NAME:STRING=libaec
        -DLIBAEC_TGZ_NAME:STRING=libaec-${LIBAEC_VERSION}.tar.gz
        -DLIBAEC_TGZ_ORIGPATH:STRING=https://github.com/MathisRosenhauer/libaec/releases/download/v${LIBAEC_VERSION}
        -DLIBAEC_USE_LOCALCONTENT:BOOL=OFF
        -DHDF_PACKAGE_NAMESPACE:STRING=ct
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(EIGEN_VERSION 3.4.0)
ExternalProject_Add(
    eigen
    URL https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.bz2
    URL_HASH SHA256=b4c198460eba6f28d34894e3a5710998818515104d6e74e5cc331ce31e46e626
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DEIGEN_BUILD_DOC:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(YAML_CPP_VERSION 0.8.0)
ExternalProject_Add(
    yamlcpp
    URL https://github.com/jbeder/yaml-cpp/archive/refs/tags/${YAML_CPP_VERSION}.tar.gz
    URL_HASH SHA256=fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16
    CMAKE_GENERATOR Ninja
    CMAKE_ARGS
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DYAML_CPP_FORMAT_SOURCE:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DBUILD_SHARED_LIBS:BOOL=ON
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(SUNDIALS_VERSION 7.4.0)
ExternalProject_Add(
    sundials
    URL https://github.com/LLNL/sundials/releases/download/v${SUNDIALS_VERSION}/sundials-${SUNDIALS_VERSION}.tar.gz
    URL_HASH SHA256=679ddacdd77610110e613164e8297d6d0cd35bae8e9c3afc8e8ff6f99a1c2a7b
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DEXAMPLES_ENABLE_C:BOOL=OFF
        -DEXAMPLES_INSTALL:BOOL=OFF
        -DBUILD_ARKODE:BOOL=OFF
        -DBUILD_CVODE:BOOL=OFF
        -DBUILD_IDA:BOOL=OFF
        -DBUILD_KINSOL:BOOL=OFF
        -DBUILD_CPODES:BOOL=OFF
        -DENABLE_LAPACK:BOOL=ON
        -DBLA_VENDOR:STRING=OpenBLAS
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

set(FMT_VERSION 11.2.0)
ExternalProject_Add(
    fmt
    URL https://github.com/fmtlib/fmt/releases/download/${FMT_VERSION}/fmt-${FMT_VERSION}.zip
    URL_HASH SHA256=203eb4e8aa0d746c62d8f903df58e0419e3751591bb53ff971096eaa0ebd4ec3
    CMAKE_GENERATOR Ninja
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_INSTALL_LIBDIR:STRING=lib
        -DFMT_DOC:BOOL=OFF
        -DFMT_TEST:BOOL=OFF
        -DBUILD_SHARED_LIBS:BOOL=ON
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)

# The dot before the 3 is a typo in the tag on the GitHub repo
set(HIGHFIVE_VERSION .3.1.1)
ExternalProject_Add(
    highfive
    URL https://github.com/highfive-devs/highfive/archive/refs/tags/v${HIGHFIVE_VERSION}.tar.gz
    URL_HASH SHA256=c0bc76b01868a133bf4550a07321923c5582fe3967edc102864b082e40799914
    CMAKE_GENERATOR Ninja
    CMAKE_ARGS
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DHIGHFIVE_UNIT_TESTS:BOOL=OFF
        -DHIGHFIVE_USE_BOOST:BOOL=ON
        -DHIGHFIVE_USE_EIGEN:BOOL=ON
        -DHIGHFIVE_EXAMPLES:BOOL=OFF
        -DHIGHFIVE_BUILD_DOCS:BOOL=OFF
        -DBoost_NO_BOOST_CMAKE:BOOL=OFF
    DEPENDS boost eigen libhdf5
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
)
