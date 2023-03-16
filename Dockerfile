FROM ubuntu:22.04
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

RUN apt-get update \
    apt-get install netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake

WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF \
    cmake --build build/ --target install

WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg
RUN cmake . \
    make
    
CMD [ "/bin/bash" ]    
