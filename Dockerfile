FROM jupyter/base-notebook:lab-3.6.3
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

USER root

# Install all the necessary librairies for nextsimdg along with some tools 
RUN sudo apt-get update 
RUN sudo apt-get install vim git build-essential bash-completion wget netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake --assume-yes

# Get and install Catch2 from source
WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF 
RUN sudo cmake --build build/ --target install

# Get nextsimdg source from the dedicated branch for test case
WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg

# Compile nextsimdg
RUN mkdir -p build
WORKDIR build
RUN cmake .. 
RUN make

# Add nextsimdg exe to path
ENV PATH="/tmp/nextsimdg/build:$PATH"

WORKDIR /tmp/nextsimdg/run

CMD [ "/bin/bash" ]    
