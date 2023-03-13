FROM pangeo/pangeo-notebook:2022.06.13
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

ADD environment.yml environment.yml

RUN mamba env update --prefix /srv/conda/envs/notebook --file environment.yml

RUN sudo apt-get update \
    sudo apt-get install netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake

WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF \
    sudo cmake --build build/ --target install

WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg
RUN cmake . \
    make
    
    
    
    
CMD [ "/bin/bash" ]    
