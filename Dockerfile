FROM ubuntu:22.04
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

RUN apt-get update && \
      apt-get -y install sudo

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

# this is where I was running into problems with the other approaches
RUN sudo apt-get update 

RUN sudo apt-get install git netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake --assume-yes

WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF 
RUN sudo cmake --build build/ --target install

WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg
RUN cmake . 
RUN make
    
CMD [ "/bin/bash" ]    
