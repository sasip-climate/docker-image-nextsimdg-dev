FROM jupyter/base-notebook:latest

# Maximum jobs for make
ARG MAX_JOBS=4

USER root

RUN apt-get -y -q update \
 && apt-get -y -q upgrade \
 && apt-get -y -q install \
	build-essential \
	cmake \
	git \
	libboost-log1.74-dev \
	libboost-program-options1.74-dev \
	libeigen3-dev \
	libnetcdf-c++4-dev \
	netcdf-bin \
 && rm -rf /var/lib/apt/lists/*

# Catch2 compilation
WORKDIR /build
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git \
 && cd Catch2 \
 && cmake -Bbuild -H. -DBUILD_TESTING=OFF \
 && cmake --build build/ --target install

# Get nextsimdg source from the dedicated branch for test case
WORKDIR /build
RUN git clone -b june23_demo https://github.com/nextsimdg/nextsimdg.git \
 && cd nextsimdg \
 && cmake -B build/ \
 && make -j ${MAX_JOBS} -C build
