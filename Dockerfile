FROM ubuntu:bionic

# Install prerequisite software using apt.
RUN apt-get update && apt-get install -y                                       \
    apt-transport-https                                                        \
    autoconf                                                                   \
    ca-certificates                                                            \
    g++                                                                        \
    gcc                                                                        \
    gfortran                                                                   \
    git                                                                        \
    libfftw3-dev                                                               \
    libhdf5-dev                                                                \
    libhdf5-serial-dev                                                         \
    liblapack-dev                                                              \
    libopenblas-dev                                                            \
    libopenmpi-dev                                                             \
    m4                                                                         \
    make                                                                       \
    openmpi-bin                                                                \
    python                                                                     \
    software-properties-common                                                 \
    unzip                                                                      \
    vim                                                                        \
    wget

# Install the latest release of CMake.
RUN wget -O -                                                                  \
    https://apt.kitware.com/keys/kitware-archive-latest.asc                    \
    2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get update
RUN apt-get install -y cmake cmake-curses-gui

# Install ninja v1.10.2 from release binary tarball.
WORKDIR /scratch/
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip
RUN unzip ninja-linux.zip
RUN mv ninja /usr/bin/

# Make two copies of the SPEC source code in the Docker image.
COPY . ./spec-make
COPY . ./spec-cmake

# Build SPEC from handwritten Makefile
WORKDIR /scratch/spec-make
RUN BUILD_ENV=gfortran_ubuntu make xspec

# Build SPEC using CMake
WORKDIR /scratch/spec-cmake
RUN cmake                                                                       \
    -DCMAKE_C_COMPILER=mpicc                                                    \
    -DCMAKE_Fortran_COMPILER=mpifort                                            \
    -DBLA_VENDOR=Generic                                                        \
    -GNinja                                                                     \
    -DCMAKE_INSTALL_PREFIX=install                                              \
    -S .                                                                        \
    -B build
WORKDIR /scratch/spec-cmake/build
RUN ninja install

WORKDIR /scratch/spec-cmake
CMD ["/bin/bash"]
